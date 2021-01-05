#
# Ronin SQL - A Ruby DSL for crafting SQL Injections.
#
# Copyright (c) 2007-2021 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-sql.
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

require 'ronin/sql/literals'
require 'ronin/sql/clauses'
require 'ronin/sql/injection_expr'
require 'ronin/sql/statement_list'

module Ronin
  module SQL
    #
    # Represents a SQL injection (SQLi).
    #
    # @api public
    #
    # @see http://en.wikipedia.org/wiki/SQL_injection
    #
    class Injection < StatementList

      include Literals
      include Clauses

      # Default place holder values.
      PLACE_HOLDERS = {
        integer: 1,
        decimal: 1.0,
        string:  '1',
        list:    [nil],
        column:  :id
      }

      # The type of element to escape out of
      attr_reader :escape

      # The expression that will be injected
      attr_reader :expression

      #
      # Initializes a new SQL injection.
      #
      # @param [Hash] options
      #   Additional injection options.
      #
      # @option options [:integer, :decimal, :string, :column] :escape (:integer)
      #   The type of element to escape out of.
      #
      # @option options [Boolean] :terminate
      #   Specifies whether to terminate the SQLi with a comment.
      #
      # @option options [String, Symbol, Integer] :place_holder
      #   Place-holder data.
      #
      # @yield [(injection)]
      #   If a block is given, it will be evaluated within the injection.
      #   If the block accepts an argument, the block will be called with the
      #   new injection.
      #
      # @yieldparam [Injection] injection
      #   The new injection.
      #
      def initialize(options={},&block)
        @escape       = options.fetch(:escape,:integer)

        place_holder = options.fetch(:place_holder) do
          PLACE_HOLDERS.fetch(@escape)
        end

        @expression = InjectionExpr.new(place_holder)

        super(&block)
      end

      #
      # Appends an `AND` expression to the injection.
      #
      # @yield [(expr)]
      #   The return value of the block will be used as the right-hand side
      #   operand.  If the block accepts an argument, it will be called with
      #   the injection.
      #
      # @yieldparam [InjectionExpr] expr
      #
      # @return [self]
      #
      def and(&block)
        @expression.and(&block)
        return self
      end

      #
      # Appends an `OR` expression to the injection.
      #
      # @yield [(expr)]
      #   The return value of the block will be used as the right-hand side
      #   operand. If the block accepts an argument, it will be called with
      #   the injection expression.
      #
      # @yieldparam [InjectionExp] expr
      #
      # @return [self]
      #
      def or(&block)
        @expression.or(&block)
        return self
      end

      #
      # Converts the SQL injection to SQL.
      #
      # @param [Hash] options
      #   Additional options for {Emitter#initialize}.
      #
      # @option options [Boolean] :terminate
      #   Specifies whether to terminate the injection with `;--`.
      #
      # @return [String]
      #   The raw SQL.
      #
      def to_sql(options={})
        emitter = emitter(options)
        sql     = @expression.to_sql(options)

        unless clauses.empty?
          sql << emitter.space << emitter.emit_clauses(clauses)
        end

        unless statements.empty?
          sql << ';' << emitter.space << emitter.emit_statement_list(self)
        end

        case @escape
        when :string, :list
          if (options[:terminate] || (sql[0,1] != sql[-1,1]))
            # terminate the expression
            sql << ';--'
          else
            sql = sql[0..-2]
          end

          # balance the quotes
          sql = sql[1..-1]
        else
          if options[:terminate]
            # terminate the expression
            sql << ';--'
          end
        end

        return sql
      end

    end
  end
end
