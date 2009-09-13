#
# Ronin SQL - A Ronin library providing support for SQL related security
# tasks.
#
# Copyright (c) 2007-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/code/sql/dialect'
require 'ronin/code/sql/create_table'
require 'ronin/code/sql/create_index'
require 'ronin/code/sql/create_view'
require 'ronin/code/sql/alter_table'
require 'ronin/code/sql/insert'
require 'ronin/code/sql/select'
require 'ronin/code/sql/update'
require 'ronin/code/sql/delete'
require 'ronin/code/sql/drop_table'
require 'ronin/code/sql/drop_index'
require 'ronin/code/sql/drop_view'

module Ronin
  module Code
    module SQL
      class CommonDialect < Dialect

        dialect :common

        primitives :yes, :no, :on, :off, :null

        data_type :int
        data_type :varchar, :length => true
        data_type :text
        data_type :record

        aggregators :avg, :count, :group_concat, :min, :max, :sum, :total

        statement :create_table, CreateTable
        statement :create_index, CreateIndex
        statement :create_view, CreateView
        statement :alter_table, AlterTable
        statement :insert, Insert
        statement :select, Select
        statement :update, Update
        statement :delete, Delete
        statement :drop_table, DropTable
        statement :drop_index, DropIndex
        statement :drop_view, DropView

      end
    end
  end
end
