#
# Ronin SQL - A Ruby DSL for crafting SQL Injections.
#
# Copyright (c) 2007-2013 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/formatting/sql'
require 'ronin/formatting/text'

module Ronin
  module SQL
    class Emitter

      # The case to use when emitting keywords
      attr_reader :case

      # String to use for white-space
      attr_reader :space

      #
      # Initializes the SQL Emitter.
      #
      # @param [Hash] options
      #   Emitter options.
      #
      # @option options [:lower, :upper, :random] :case (:upper)
      #   Case for keywords.
      #
      # @option options [String] :space (' ')
      #   String to use for white-space.
      #
      def initialize(options={})
        @case  = options.fetch(:case,:upper)
        @space = options.fetch(:space,' ')
      end

      #
      # Emits a SQL keyword.
      #
      # @param [Symbol, Array<Symbol>] keyword
      #   The SQL keyword.
      #
      # @return [String]
      #   The raw SQL.
      #
      def emit_keyword(keyword)
        keyword = Array(keyword).join(@space)

        case @case
        when :upper  then keyword.upcase
        when :lower  then keyword.downcase
        when :random then keyword.random_case(:probability => 0.75)
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
      # Emits the `NULL` value.
      #
      # @return ["NULL"]
      #
      def emit_null
        emit_keyword(:null)
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
        op = emit_operator(expr.operator)

        case expr
        when BinaryExpr
          left, right = emit(expr.left), emit(expr.right)

          case op
          when /^\w+$/ then "#{left} #{op} #{right}"
          else              "#{left}#{op}#{right}"
          end
        when UnaryExpr
          operand = emit(expr.operand)

          case op
          when /^\w+$/ then "#{op} #{operand}"
          else              "#{op}#{operand}"
          end
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
        name      = emit_keyword(function.name)
        arguments = function.arguments.map { |argument| emit(argument) }

        return "#{name}(#{arguments.join(',')})"
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
        when NilClass              then emit_null
        when TrueClass             then emit_true
        when FalseClass            then emit_false
        when Integer               then emit_integer(object)
        when Float                 then emit_decimal(object)
        when String                then emit_string(object)
        when Literal               then emit(object.value)
        when Field, Symbol         then emit_field(object)
        when Array                 then emit_list(object)
        when BinaryExpr, UnaryExpr then emit_expression(object)
        else
          if object.respond_to?(:to_sql)
            object.to_sql
          else
            raise(ArgumentError,"cannot emit #{object.class}")
          end
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
          sql << @space << emit(clause.argument)
        end

        return sql
      end

      #
      # Emits multiple SQL Clauses.
      #
      # @param [Array<Clause>] clauses
      #   The clauses to emit.
      #
      # @return [String]
      #   The emitted clauses.
      #
      def emit_clauses(clauses)
        clauses.map { |clause| emit_clause(clause) }.join(@space)
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
          sql << @space << emit(stmt.argument)
        end

        unless stmt.clauses.empty?
          sql << @space << emit_clauses(stmt.clauses)
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
        program.statements.map { |stmt|
          emit_statement(stmt)
        }.join(";#{@space}")
      end

    end
  end
end
