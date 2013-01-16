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

require 'ronin/sql/clause'
require 'ronin/sql/clauses'
require 'ronin/sql/operators'
require 'ronin/sql/emitter'

module Ronin
  module SQL
    #
    # Represents a SQL Statement.
    #
    class Statement < Struct.new(:keyword,:argument)

      include Operators
      include Clauses

      #
      # Initializes a new SQL statement.
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
      def initialize(keyword,argument=nil,&block)
        super(keyword,argument)

        if block
          case block.arity
          when 1 then block.call(self)
          else        instance_eval(&block)
          end
        end
      end

      #
      # Converts the statement into raw SQL.
      #
      # @param [Hash] options
      #   Additional syntax options.
      #
      # @return [String]
      #   The raw SQL.
      #
      def to_sql(options={})
        Emitter.new(options).emit_statement(self)
      end

      alias to_s   to_sql
      alias to_str to_s

    end
  end
end