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

module Ronin
  module SQL
    #
    # Generates raw SQL.
    #
    class Emitter

      # The case to use when emitting keywords
      attr_reader :case

      # String to use for white-space
      attr_reader :space

      # Type of String quotes to use
      attr_reader :quotes

      #
      # Initializes the SQL Emitter.
      #
      # @param [Hash] options
      #   Emitter options.
      #
      # @option options [:lower, :upper, :random, nil] :case
      #   Case for keywords.
      #
      # @option options [String] :space (' ')
      #   String to use for white-space.
      #
      # @option options [:single, :double] :quotes (:single)
      #   Type of quotes to use for Strings.
      #
      def initialize(options={})
        @case  = options[:case]
        @space = options.fetch(:space,' ')
        @quotes = options.fetch(:quotes,:single)
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
        when :random
          keyword.tap do
            (keyword.length / 2).times do
              index = rand(keyword.length)
              keyword[index] = keyword[index].swapcase
            end
          end
        else
          keyword
        end
      end

      #
      # Emits a SQL operator.
      #
      # @param [Array<Symbol>, Symbol] op
      #   The operator symbol.
      #
      # @return [String]
      #   The raw SQL.
      #
      def emit_operator(op)
        case op
        when /^\W+$/          then op.to_s
        else                       emit_keyword(op)
        end
      end

      #
      # Emits the `NULL` value.
      #
      # @return ["NULL"]
      #
      def emit_null
        emit_keyword(:NULL)
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
        string.sql_escape(@quotes)
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
        name = emit_keyword(field.name)

        if field.parent
          name = "#{emit_field(field.parent)}.#{name}"
        end

        return name
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
        '(' + list.map { |element| emit(element) }.join(',') + ')'
      end

      #
      # Emits a list of columns and assigned values.
      #
      # @param [Hash{Field,Symbol => Object}] values
      #   The column names and values.
      #
      # @return [String]
      #   The raw SQL.
      #
      def emit_assignments(values)
        values.map { |key,value|
          "#{emit_keyword(key)}=#{emit(value)}"
        }.join(',')
      end

      #
      # Emits a value used in an expression.
      #
      # @param [Statement, #to_sql] operand
      #   The operand to emit.
      #
      # @return [String]
      #   The raw SQL.
      #
      def emit_argument(operand)
        case operand
        when Statement then "(#{emit_statement(operand)})"
        else                emit(operand)
        end
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
          left, right = emit_argument(expr.left), emit_argument(expr.right)

          case op
          when /^\W+$/ then "#{left}#{op}#{right}"
          else              [left, op, right].join(@space)
          end
        when UnaryExpr
          operand = emit_argument(expr.operand)

          case expr.operator
          when /^\W+$/ then "#{op}#{operand}"
          else              [op, operand].join(@space)
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
        arguments = function.arguments.map { |value| emit_argument(value) }

        return "#{name}(#{arguments.join(',')})"
      end

      #
      # Emits a SQL object.
      #
      # @param [#to_sql] object
      #   The SQL object.
      #
      # @return [String]
      #   The raw SQL.
      #
      # @raise [ArgumentError]
      #   Could not emit an unknown SQL object.
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
        when Symbol                then emit_keyword(object)
        when Field                 then emit_field(object)
        when Array                 then emit_list(object)
        when Hash                  then emit_assignments(object)
        when BinaryExpr, UnaryExpr then emit_expression(object)
        when Function              then emit_function(object)
        when Clause                then emit_clause(object)
        when Statement             then emit_statement(object)
        when StatementList         then emit_statement_list(object)
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
          sql << @space << emit_argument(clause.argument)
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
          case stmt.argument
          when Array
            sql << @space << if stmt.argument.length == 1
                               emit_argument(stmt.argument[0])
                             else
                               emit_list(stmt.argument)
                             end
          else
            sql << @space << emit_argument(stmt.argument)
          end
        end

        unless stmt.clauses.empty?
          sql << @space << emit_clauses(stmt.clauses)
        end

        return sql
      end

      #
      # Emits a full SQL statement list.
      #
      # @param [StatementList] list
      #   The SQL statement list.
      #
      # @return [String]
      #   The raw SQL.
      #
      def emit_statement_list(list)
        list.statements.map { |stmt|
          emit_statement(stmt)
        }.join(";#{@space}")
      end

    end
  end
end
