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
      # @param [Hash] options
      #   Additional options for {Emitter#initialize}.
      #
      # @return [String]
      #   The raw SQL.
      #
      def to_sql(options={})
        emitter(options).emit(@expression)
      end

    end
  end
end
