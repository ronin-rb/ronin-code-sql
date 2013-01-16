#
# Ronin SQL - A Ruby DSL for crafting SQL Injections.
#
# Copyright (c) 2007-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin SQL.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#

require 'ronin/sql/unary_expr'
require 'ronin/sql/binary_expr'
require 'ronin/sql/field'

require 'ronin/formatting/sql'

module Ronin
  module SQL
    class Emitter

      attr_reader :case

      #
      # Initializes the SQL Emitter.
      #
      def initialize(options={})
        @case = options.fetch(:case,:upper)
      end

      #
      # Emits a SQL keyword.
      #
      # @param [Symbol] keyword
      #   The SQL keyword.
      #
      # @return [String]
      #   The raw SQL.
      #
      def emit_keyword(keyword)
        keyword = keyword.to_s

        case @case
        when :upper then keyword.upcase
        when :lower then keyword.downcase
        end
      end

      #
      # Emits a SQL operator.
      #
      # @param [Symbol] op
      #   The operator symbol.
      #
      # @return [String]
      #   The raw SQL.
      #
      def emit_operator(op)
        op = op.to_s

        case op
        when /^[A-Z]+$/ then emit_keyword(op)
        else                 op
        end
      end

      #
      # Emits a `false` value.
      #
      # @return [String]
      #   The raw SQL.
      #
      def emit_false
        "1=0"
      end

      #
      # Emits a `true` value.
      #
      # @return [String]
      #   The raw SQL.
      #
      def emit_true
        "1=1"
      end

      #
      # Emits a SQL Integer.
      #
      # @param [Integer] int
      #   The Integer.
      #
      # @return [String]
      #   The raw SQL.
      #
      def emit_integer(int)
        int.to_s
      end

      #
      # Emits a SQL Decimal.
      #
      # @param [Float] decimal
      #   The decimal.
      #
      # @return [String]
      #   The raw SQL.
      #
      def emit_decimal(decimal)
        decimal.to_s
      end

      #
      # Emits a SQL String.
      #
      # @param [String] string
      #   The String.
      #
      # @return [String]
      #   The raw SQL.
      #
      def emit_string(string)
        string.sql_escape
      end

      #
      # Emits a SQL field.
      #
      # @param [Field, Symbol, String] field
      #   The SQL field.
      #
      # @return [String]
      #   The raw SQL.
      #
      def emit_field(field)
        field.to_s
      end

      #
      # Emits a list of elements.
      #
      # @param [#map] list
      #   The list of elements.
      #
      # @return [String]
      #   The raw SQL.
      #
      def emit_list(list)
        list.map { |element| emit(element) }.join(',')
      end

      #
      # Emits a SQL expression.
      #
      # @param [BinaryExpr, UnaryExpr] expr
      #   The SQL expression.
      #
      # @return [String]
      #   The raw SQL.
      #
      def emit_expression(expr)
        case expr
        when BinaryExpr
          "#{emit(expr.left)} #{emit_operator(expr.op)} #{emit(expr.right)}"
        when UnaryExpr
          "#{emit_operator(expr.op)} #{emit(expr.expr)}"
        end
      end

      #
      # Emits a SQL function.
      #
      # @param [Function] function
      #   The SQL function.
      #
      # @return [String]
      #   The raw SQL.
      #
      def emit_function(function)
        emit_keyword(function.name) << function.arguments.map { |argument|
          emit(argument)
        }.join(',')
      end

      #
      # Emits a SQL object.
      #
      # @param [Object] object
      #   The SQL object.
      #
      # @return [String]
      #   The raw SQL.
      #
      # @raise [ArgumentError]
      #   Could not emit the SQL object.
      #
      def emit(object)
        case object
        when NilClass              then emit_keyword(:null)
        when TrueClass             then emit_true
        when FalseClass            then emit_false
        when Integer               then emit_integer(object)
        when Float                 then emit_decimal(object)
        when String                then emit_string(object)
        when Field, Symbol         then emit_field(object)
        when Field                 then emit_field(object)
        when Array                 then emit_list(object)
        when BinaryExpr, UnaryExpr then emit_expression(object)
        else
          raise(ArgumentError,"cannot emit #{object.class}")
        end
      end

      #
      # Emits a SQL Clause.
      #
      # @param [Clause] clause
      #   The SQL Clause.
      #
      # @return [String]
      #   The raw SQL.
      #
      def emit_clause(clause)
        sql = emit_keyword(clause.keyword)

        unless clause.argument.nil?
          sql << ' ' << emit(clause.argument)
        end

        return sql
      end

      #
      # Emits a SQL Statement.
      #
      # @param [Statement] stmt
      #   The SQL Statement.
      #
      # @return [String]
      #   The raw SQL.
      #
      def emit_statement(stmt)
        sql = emit_keyword(stmt.keyword)

        unless stmt.argument.nil?
          sql << ' ' << emit(stmt.argument)
        end

        stmt.clauses.each do |clause|
          sql << ' ' << emit_clause(clause)
        end

        return sql
      end

      #
      # Emits a full SQL program.
      #
      # @param [Program] program
      #   The SQL Program.
      #
      # @return [String]
      #   The raw SQL.
      #
      def emit_program(program)
        program.statements.map { |stmt| emit_statement(stmt) }.join('; ')
      end

    end
  end
end
