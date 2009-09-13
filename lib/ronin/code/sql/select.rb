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
require 'ronin/code/sql/fields_clause'
require 'ronin/code/sql/from_clause'
require 'ronin/code/sql/join_clause'
require 'ronin/code/sql/where_clause'
require 'ronin/code/sql/group_by_clause'
require 'ronin/code/sql/having_clause'
require 'ronin/code/sql/order_by_clause'
require 'ronin/code/sql/limit_clause'
require 'ronin/code/sql/offset_clause'
require 'ronin/code/sql/union_clause'
require 'ronin/code/sql/union_all_clause'

module Ronin
  module Code
    module SQL
      class Select < Statement

        clause :fields, FieldsClause
        clause :from, FromClause
        clause :join, JoinClause
        clause :where, WhereClause
        clause :group_by, GroupByClause
        clause :having, HavingClause
        clause :order_by, OrderByClause
        clause :limit, LimitClause
        clause :offset, OffsetClause
        clause :union, UnionClause
        clause :union_all, UnionAllClause

        def initialize(dialect,options={},&block)
          super(dialect,options)

          if options[:distinct_rows]
            self.distinct_rows!
          end

          if options[:all_rows]
            self.all_rows!
          end

          unless options[:fields]
            fields(all)
          end

          instance_eval(&block) if block
        end

        def all_rows!
          @all_rows = true
          return self
        end

        def all_rows?
          @all_rows == true
        end

        def distinct_rows!
          @distinct_rows = true
          return self
        end

        def distinct_rows?
          @distinct_rows == true
        end

        def emit
          tokens = emit_token('SELECT')

          if @distinct_rows
            tokens += emit_token('DISTINCT')
          elsif @all_rows
            tokens += emit_token('ALL')
          end
          
          return tokens + super
        end

      end
    end
  end
end
