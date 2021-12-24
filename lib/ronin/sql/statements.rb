#
# Ronin SQL - A Ruby DSL for crafting SQL Injections.
#
# Copyright (c) 2007-2021 Hal Brodigan (postmodern.mod3 at gmail.com)
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

module Ronin
  module SQL
    #
    # Methods for creating common SQL {Statement Statements}.
    #
    # @api public
    #
    module Statements
      #
      # Creates an arbitrary statement.
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
      #   The new statement.
      #
      def statement(keyword,argument=nil,&block)
        Statement.new(keyword,argument,&block)
      end

      #
      # Creates a new `SELECT` statement.
      #
      # @param [Array<Field, Symbol>] columns
      #   The columns to select.
      #
      # @return [Statement]
      #   The new statement.
      #
      def select(*columns,&block)
        statement(:SELECT,columns,&block)
      end

      #
      # Creates a new `INSERT` statement.
      #
      # @return [Statement]
      #   The new statement.
      #
      def insert(&block)
        statement(:INSERT,&block)
      end

      #
      # Creates a new `UPDATE` statement.
      #
      # @param [Field, Symbol] table
      #   The table to update.
      #
      # @return [Statement]
      #   The new statement.
      #
      def update(table,&block)
        statement(:UPDATE,table,&block)
      end

      #
      # Creates a new `DELETE` statement.
      #
      # @param [Field, Symbol] table
      #   The table to delete from.
      #
      # @return [Statement]
      #   The new statement.
      #
      def delete(table,&block)
        statement([:DELETE, :FROM],table,&block)
      end

      #
      # Creates a new `DROP TABLE` statement.
      #
      # @param [Field, Symbol] table
      #   The table to drop.
      #
      # @return [Statement]
      #   The new statement.
      #
      def drop_table(table,&block)
        statement([:DROP, :TABLE],table,&block)
      end
    end
  end
end
