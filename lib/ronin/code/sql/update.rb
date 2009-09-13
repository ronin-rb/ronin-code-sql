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

require 'ronin/code/sql/statement'
require 'ronin/code/sql/set_clause'
require 'ronin/code/sql/where_clause'

module Ronin
  module Code
    module SQL
      class Update < Statement

        clause :set, SetClause
        clause :where, WhereClause

        def initialize(dialect,table=nil,options={},&block)
          @table = table

          super(dialect,options,&block)
        end

        def table(name=nil)
          @table = name if name
          return @table
        end

        def emit
          emit_token('UPDATE') + emit_value(@table) + super
        end

      end
    end
  end
end
