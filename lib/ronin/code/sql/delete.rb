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

module Ronin
  module Code
    module SQL
      class Delete < Statement

        def initialize(style,table=nil,where_expr=nil,&block)
          @table = table || everything
          @where = where_expr

          super(style,&block)
        end

        def from(table)
          @table = table
          return self
        end

        def where(expr)
          @where = expr
          return self
        end

        def compile
          compile_expr(keyword_delete,@table,where?)
        end

        protected

        keyword :delete, 'DELETE FROM'
        keyword :where

        def where?
          compile_expr(keyword_where,@where) if @where
        end

      end
    end
  end
end
