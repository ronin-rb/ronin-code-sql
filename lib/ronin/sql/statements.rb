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

module Ronin
  module SQL
    module Statements
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
        Statement.new(:SELECT,columns,&block)
      end

      #
      # Creates a new `INSERT` statement.
      #
      # @return [Statement]
      #   The new statement.
      #
      def insert(&block)
        Statement.new(:"INSERT INTO",&block)
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
        Statement.new(:UPDATE,table,&block)
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
        Statement.new(:"DELETE FROM",table,&block)
      end
    end
  end
end