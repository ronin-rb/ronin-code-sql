#
#--
# Ronin SQL - A Ronin library providing support for SQL related security
# tasks.
#
# Copyright (c) 2007-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#++
#

require 'ronin/code/sql/statement'
require 'ronin/code/sql/rename_to_clause'
require 'ronin/code/sql/add_column_clause'

module Ronin
  module Code
    module SQL
      class AlterTable < Statement

        clause :rename_to, RenameToClause
        clause :add_column, AddColumnClause

        def initialize(program,options={},&block)
          @table = options[:table]

          super(program,options,&block)
        end

        def table(name)
          @table = name
          return self
        end

        def emit
          [Keyword.new('ALTER TABLE')] + emit_value(@table) + super
        end

      end
    end
  end
end
