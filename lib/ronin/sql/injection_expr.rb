#
# Ronin SQL - A Ruby DSL for crafting SQL Injections.
#
# Copyright (c) 2007-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-sql.
#
# ronin-sql is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-sql is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-sql.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/sql/binary_expr'
require 'ronin/sql/literals'
require 'ronin/sql/fields'
require 'ronin/sql/functions'
require 'ronin/sql/statements'
require 'ronin/sql/emittable'

module Ronin
  module SQL
    #
    # @api private
    #
    # @since 1.1.0
    #
    class InjectionExpr

      include Literals
      include Fields
      include Functions
      include Statements
      include Emittable

      # The expression that will be injected
      attr_reader :expression

      #
      # Initializes the new expression to inject.
      #
      # @param [String, Integer, Float, Array, Symbol] initial_value
      #   The initial value for the expression.
      #
      def initialize(initial_value)
        @expression = initial_value
      end

      #
      # Appends an `AND` expression to the injection.
      #
      # @yield [(self)]
      #   The return value of the block will be used as the right-hand side
      #   operand.  If the block accepts an argument, it will be called with
      #   the injection expression.
      #
      # @return [self]
      #
      def and(&block)
        value = case block.arity
                when 0 then instance_eval(&block)
                else        block.call(self)
                end

        @expression = BinaryExpr.new(@expression,:AND,value)
        return self
      end

      #
      # Appends an `OR` expression to the injection.
      #
      # @yield [(self)]
      #   The return value of the block will be used as the right-hand side
      #   operand. If the block accepts an argument, it will be called with
      #   the injection expression.
      #
      # @return [self]
      #
      def or(&block)
        value = case block.arity
                when 0 then instance_eval(&block)
                else        block.call(self)
                end

        @expression = BinaryExpr.new(@expression,:OR,value)
        return self
      end

      #
      # Emits the injection expression.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments for {Emitter#initialize}.
      #
      # @return [String]
      #   The raw SQL.
      #
      def to_sql(**kwargs)
        emitter(**kwargs).emit(@expression)
      end

    end
  end
end
