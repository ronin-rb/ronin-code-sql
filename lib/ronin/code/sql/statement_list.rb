# frozen_string_literal: true
#
# ronin-code-sql - A Ruby DSL for crafting SQL Injections.
#
# Copyright (c) 2007-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require_relative 'field'
require_relative 'fields'
require_relative 'unary_expr'
require_relative 'binary_expr'
require_relative 'functions'
require_relative 'statement'
require_relative 'statements'
require_relative 'emittable'

module Ronin
  module Code
    module SQL
      #
      # Represents a list of SQL {Statements Statement}.
      #
      # @api public
      #
      class StatementList

        include Fields
        include Functions
        include Statements
        include Emittable

        # The list of statements
        attr_reader :statements

        #
        # Initializes a new SQL statement list.
        #
        # @yield [(statements)]
        #   If a block is given, it will be evaluated within the statement list.
        #   If the block accepts an argument, the block will be called with the
        #   new statement list.
        #
        # @yieldparam [StatementList] statements
        #   The new statement list.
        #
        def initialize(&block)
          @statements = []

          if block
            case block.arity
            when 0 then instance_eval(&block)
            else        block.call(self)
            end
          end
        end

        #
        # Appends a statement.
        #
        # @param [Statement] statement
        #   The SQL statement.
        #
        # @return [self]
        #
        def <<(statement)
          @statements << statement
          return self
        end

        #
        # Appends an arbitrary statement.
        #
        # @param [Symbol] keyword
        #   Name of the statement.
        #
        # @param [Object] argument
        #   Additional argument for the statement.
        #
        # @yield [(statement)]
        #   If a block is given, it will be called.
        #
        # @yieldparam [Statement] statement
        #   If the block accepts an argument, it will be passed the new statement.
        #   Otherwise the block will be evaluated within the statement.
        #
        # @return [Statement]
        #   The newly created statement.
        #
        def statement(keyword,argument=nil,&block)
          new_statement = super

          self << new_statement
          return new_statement
        end

      end
    end
  end
end
