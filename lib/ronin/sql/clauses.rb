#
# Ronin SQL - A Ruby DSL for crafting SQL Injections.
#
# Copyright (c) 2007-2013 Hal Brodigan (postmodern.mod3 at gmail.com)
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
    module Clauses
      #
      # The defined clauses of the statement.
      #
      # @return [Array<Clause>]
      #   The clauses defined thus far.
      #
      def clauses
        @clauses ||= []
      end

      #
      # Appends an arbitrary clause.
      #
      # @param [Symbol] keyword
      #   The name of the clause.
      #
      # @param [Object] argument
      #   Additional argument for the clause.
      #
      # @yield [(clause)]
      #   If a block is given, the return value will be used as the argument.
      #
      # @yieldparam [Clause] clause
      #   If the block accepts an argument, it will be passed the new clause.
      #   Otherwise the block will be evaluated within the clause.
      #
      # @return [self]
      #
      def clause(keyword,argument=nil,&block)
        clauses << Clause.new(keyword,argument,&block)
        return self
      end

      #
      # Appends a `FROM` clause.
      #
      def from(table=nil,&block)
        clause(:FROM,table,&block)
      end

      #
      # Appends an `INTO` clause.
      #
      def into(table=nil,&block)
        clause(:INTO,table,&block)
      end

      #
      # Appends a `WHERE` clause.
      #
      def where(&block)
        clause(:WHERE,&block)
      end

      #
      # Appends a `JOIN` clause.
      #
      def join(table=nil,&block)
        clause(:JOIN,table,&block)
      end

      #
      # Appends a `INNER JOIN` clause.
      #
      def inner_join(table=nil,&block)
        clause(:"INNER JOIN",table,&block)
      end

      #
      # Appends a `LEFT JOIN` clause.
      #
      def left_join(table=nil,&block)
        clause(:"LEFT JOIN",table,&block)
      end

      #
      # Appends a `RIGHT JOIN` clause.
      #
      def right_join(table=nil,&block)
        clause(:"RIGHT JOIN",table,&block)
      end

      #
      # Appends a `FULL JOIN` clause.
      #
      def full_join(table=nil,&block)
        clause(:"FULL JOIN",table,&block)
      end

      #
      # Appends a `ON` clause.
      #
      def on(&block)
        clause(:ON,&block)
      end

      #
      # Appends a `UNION` clause.
      #
      def union(&block)
        clause(:UNION,&block)
      end

      #
      # Appends a `GROUP BY` clause.
      #
      # @param [Array<Field, Symbol>] columns
      #   The columns for `GROUP BY`.
      #
      def group_by(*columns,&block)
        clause(:"GROUP BY",columns,&block)
      end

      #
      # Appends a `HAVING` clause.
      #
      def having(&block)
        clause(:HAVING,&block)
      end

      #
      # Appends a `LIMIT` clause.
      #
      def limit(value=nil,&block)
        clause(:LIMIT,value,&block)
      end

      #
      # Appends a `OFFSET` clause.
      #
      def offset(value=nil,&block)
        clause(:OFFSET,value,&block)
      end

      #
      # Appends a `TOP` clause.
      #
      def top(value=nil,&block)
        clause(:TOP,value,&block)
      end

      #
      # Appends a `INTO` clause.
      #
      def into(table=nil)
        clause(:INTO,table)
      end

      #
      # Appends a `VALUES` clause.
      #
      def values(*values)
        clause(:VALUES,values)
      end

      #
      # Appends a `DEFAULT VALUES` clause.
      #
      def default_values
        clause(:"DEFAULT VALUES")
      end

      #
      # Appends a `SET` clause.
      #
      def set(values={})
        clause(:SET,values)
      end

      #
      # Appends a `INDEXED BY` clause.
      #
      def indexed_by(name,&block)
        clause(:"INDEXED BY",name,&block)
      end

      #
      # Appends a `NOT INDEXED` clause.
      #
      def not_indexed
        clause(:"NOT INDEXED")
      end
    end
  end
end
