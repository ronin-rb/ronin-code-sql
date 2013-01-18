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

require 'ronin/sql/fields'
require 'ronin/sql/functions'
require 'ronin/sql/statement'
require 'ronin/sql/statements'
require 'ronin/sql/emittable'

module Ronin
  module SQL
    #
    # Represents a SQL Program.
    #
    class Program

      include Fields
      include Functions
      include Statements
      include Emittable

      # The statements of the program
      attr_reader :statements

      #
      # Initializes a new SQL program.
      #
      def initialize
        @statements = []
      end

      #
      # Appends a statement to the program.
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
      # Appends an arbitrary statement to the program.
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
        new_statement = super(keyword,argument,&block)

        self << new_statement
        return new_statement
      end

      #
      # Converts the SQL program into raw SQL.
      #
      # @param [Hash] options
      #   Additional syntax options.
      #
      # @return [String]
      #   The raw SQL.
      #
      def to_sql(options={})
        Emitter.new(options).emit_program(self)
      end

    end
  end
end
