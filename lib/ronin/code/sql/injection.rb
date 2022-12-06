# frozen_string_literal: true
#
# ronin-code-sql - A Ruby DSL for crafting SQL Injections.
#
# Copyright (c) 2007-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# ronin-code-sql is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-code-sql is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-code-sql.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/code/sql/literals'
require 'ronin/code/sql/clauses'
require 'ronin/code/sql/injection_expr'
require 'ronin/code/sql/statement_list'

module Ronin
  module Code
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
        #
        # @return [:integer, :decimal, :string, :column]
        attr_reader :escape

        # The expression that will be injected
        #
        # @return [InjectionExpr]
        attr_reader :expression

        #
        # Initializes a new SQL injection.
        #
        # @param [:integer, :decimal, :string, :column] escape
        #   The type of element to escape out of.
        #
        # @param [String, Symbol, Integer] place_holder
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
        def initialize(escape:       :integer,
                       place_holder: PLACE_HOLDERS.fetch(escape),
                       &block)
          @escape     = escape
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
        # @yieldparam [InjectionExpr] expr
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
        # @param [Boolean] terminate
        #   Specifies whether to terminate the injection with `;--`.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {Emitter#initialize}.
        #
        # @return [String]
        #   The raw SQL.
        #
        def to_sql(terminate: false, **kwargs)
          emitter = emitter(**kwargs)
          sql     = @expression.to_sql(**kwargs)

          unless clauses.empty?
            sql << emitter.space << emitter.emit_clauses(clauses)
          end

          unless statements.empty?
            sql << ';' << emitter.space << emitter.emit_statement_list(self)
          end

          case @escape
          when :string, :list
            if (terminate || (sql[0,1] != sql[-1,1]))
              # terminate the expression
              sql << ';--'
            else
              sql = sql[0..-2]
            end

            # balance the quotes
            sql = sql[1..-1]
          else
            if terminate
              # terminate the expression
              sql << ';--'
            end
          end

          return sql
        end

      end
    end
  end
end
