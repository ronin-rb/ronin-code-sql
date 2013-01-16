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
    module Clauses
      def clauses
        @clauses ||= []
      end

      #
      # Appends a `FROM` clause.
      #
      def from(table=nil,&block)
        clauses << Clause.new(:FROM,table,&block)
        return self
      end

      #
      # Appends a `WHERE` clause.
      #
      def where(&block)
        clauses << Clause.new(:WHERE,&block)
        return self
      end

      #
      # Appends a `JOIN` clause.
      #
      def join(table=nil,&block)
        clauses << Clause.new(:JOIN,table,&block)
        return self
      end

      #
      # Appends a `INNER JOIN` clause.
      #
      def inner_join(table=nil,&block)
        clauses << Clause.new(:"INNER JOIN",table,&block)
        return self
      end

      #
      # Appends a `LEFT JOIN` clause.
      #
      def left_join(table=nil,&block)
        clauses << Clause.new(:"LEFT JOIN",table,&block)
        return self
      end

      #
      # Appends a `RIGHT JOIN` clause.
      #
      def right_join(table=nil,&block)
        clauses << Clause.new(:"RIGHT JOIN",table,&block)
        return self
      end

      #
      # Appends a `FULL JOIN` clause.
      #
      def full_join(table=nil,&block)
        clauses << Clause.new(:"FULL JOIN",table,&block)
        return self
      end

      #
      # Appends a `ON` clause.
      #
      def on(&block)
        clauses << Clause.new(:ON,&block)
        return self
      end

      #
      # Appends a `UNION` clause.
      #
      def union(&block)
        clauses << Clause.new(:UNION,&block)
        return self
      end

      #
      # Appends a `GROUP BY` clause.
      #
      # @param [Array<Field, Symbol>] columns
      #   The columns for `GROUP BY`.
      #
      def group_by(*columns,&block)
        clauses << Clause.new(:"GROUP BY",columns,&block)
        return self
      end

      #
      # Appends a `HAVING` clause.
      #
      def having(&block)
        clauses << Clause.new(:HAVING,&block)
        return self
      end

      #
      # Appends a `LIMIT` clause.
      #
      def limit(value=nil,&block)
        clauses << Clause.new(:LIMIT,value,&block)
        return self
      end

      #
      # Appends a `OFFSET` clause.
      #
      def offset(value=nil,&block)
        clauses << Clause.new(:OFFSET,value,&block)
        return self
      end

      #
      # Appends a `TOP` clause.
      #
      def top(value=nil,&block)
        clauses << Clause.new(:TOP,value,&block)
        return self
      end

      #
      # Appends a `INTO` clause.
      #
      def into(table=nil)
        clauses << Clause.new(:INTO,table)
        return self
      end

      #
      # Appends a `VALUES` clause.
      #
      def values(*values)
        clauses << Clause.new(:VALUES,values)
        return self
      end

      #
      # Appends a `DEFAULT VALUES` clause.
      #
      def default_values
        clauses << Clause.new(:"DEFAULT VALUES")
        return self
      end

      #
      # Appends a `SET` clause.
      #
      def set(values={})
        clauses << Clause.new(:SET,values)
        return self
      end

      #
      # Appends a `INDEXED BY` clause.
      #
      def indexed_by(name,&block)
        clauses << Clause.new(:"INDEXED BY",name,&block)
        return self
      end

      #
      # Appends a `NOT INDEXED` clause.
      #
      def not_indexed
        clauses << Clause.new(:"NOT INDEXED")
        return self
      end
    end
  end
end
