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

require 'ronin/sql/field'
require 'ronin/sql/fields'
require 'ronin/sql/unary_expr'
require 'ronin/sql/binary_expr'
require 'ronin/sql/functions'
require 'ronin/sql/statement'
require 'ronin/sql/statements'
require 'ronin/sql/emittable'

module Ronin
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
