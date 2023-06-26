# frozen_string_literal: true
#
# ronin-code-sql - A Ruby DSL for crafting SQL Injections.
#
# Copyright (c) 2007-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# ronin-code-sql is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-code-sql is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-code-sql.  If not, see <https://www.gnu.org/licenses/>.
#

module Ronin
  module Code
    module SQL
      #
      # Methods for creating common SQL {Clause Clauses}.
      #
      # @api public
      #
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
        # @param [Field, Symbol] table
        #   The table to select from.
        #
        # @return [self]
        #
        def from(table=nil,&block)
          clause(:FROM,table,&block)
        end

        #
        # Appends an `INTO` clause.
        #
        # @param [Field, Symbol, nil] table
        #   The table to insert into.
        #
        # @return [self]
        #
        def into(table=nil,&block)
          clause(:INTO,table,&block)
        end

        #
        # Appends a `WHERE` clause.
        #
        # @return [self]
        #
        def where(&block)
          clause(:WHERE,&block)
        end

        #
        # Appends a `JOIN` clause.
        #
        # @param [Field, Symbol] table
        #   The table to join.
        #
        # @return [self]
        #
        def join(table=nil,&block)
          clause(:JOIN,table,&block)
        end

        #
        # Appends a `INNER JOIN` clause.
        #
        # @param [Field, Symbol] table
        #   The table to join.
        #
        # @return [self]
        #
        def inner_join(table=nil,&block)
          clause([:INNER, :JOIN],table,&block)
        end

        #
        # Appends a `LEFT JOIN` clause.
        #
        # @param [Field, Symbol] table
        #   The table to join.
        #
        # @return [self]
        #
        def left_join(table=nil,&block)
          clause([:LEFT, :JOIN],table,&block)
        end

        #
        # Appends a `RIGHT JOIN` clause.
        #
        # @param [Field, Symbol] table
        #   The table to join.
        #
        # @return [self]
        #
        def right_join(table=nil,&block)
          clause([:RIGHT, :JOIN],table,&block)
        end

        #
        # Appends a `FULL JOIN` clause.
        #
        # @param [Field, Symbol] table
        #   The table to join.
        #
        # @return [self]
        #
        def full_join(table=nil,&block)
          clause([:FULL, :JOIN],table,&block)
        end

        #
        # Appends a `ON` clause.
        #
        # @return [self]
        #
        def on(&block)
          clause(:ON,&block)
        end

        #
        # Appends a `UNION` clause.
        #
        # @return [self]
        #
        def union(&block)
          clause(:UNION,&block)
        end

        #
        # Appends a `UNION ALL` clause.
        #
        # @return [self]
        #
        # @since 1.1.0
        #
        def union_all(&block)
          clause([:UNION, :ALL],&block)
        end

        #
        # Appends a `GROUP BY` clause.
        #
        # @param [Array<Field, Symbol>] columns
        #   The columns for `GROUP BY`.
        #
        # @return [self]
        #
        def group_by(*columns,&block)
          clause([:GROUP, :BY],columns,&block)
        end

        #
        # Appends a `ORDER BY` clause.
        #
        # @param [Array<Field, Symbol>] columns
        #   The columns for `ORDER BY`.
        #
        # @return [self]
        #
        def order_by(*columns,&block)
          clause([:ORDER, :BY],columns,&block)
        end

        #
        # Appends a `HAVING` clause.
        #
        # @return [self]
        #
        def having(&block)
          clause(:HAVING,&block)
        end

        #
        # Appends a `LIMIT` clause.
        #
        # @param [Integer] value
        #   The maximum number of rows to select.
        #
        # @return [self]
        #
        def limit(value,&block)
          clause(:LIMIT,value,&block)
        end

        #
        # Appends a `OFFSET` clause.
        #
        # @param [Integer] value
        #   The index to start selecting at within the result set.
        #
        # @return [self]
        #
        def offset(value,&block)
          clause(:OFFSET,value,&block)
        end

        #
        # Appends a `TOP` clause.
        #
        # @param [Integer] value
        #   The number of top rows to select.
        #
        # @return [self]
        #
        def top(value,&block)
          clause(:TOP,value,&block)
        end

        #
        # Appends a `VALUES` clause.
        #
        # @param [Array] values
        #   The values to insert.
        #
        # @return [self]
        #
        def values(*values)
          clause(:VALUES,values)
        end

        #
        # Appends a `DEFAULT VALUES` clause.
        #
        # @return [self]
        #
        def default_values
          clause([:DEFAULT, :VALUES])
        end

        #
        # Appends a `SET` clause.
        #
        # @param [Hash{Field,Symbol => Object}] values
        #   The columns and values to update.
        #
        # @return [self]
        #
        def set(values={})
          clause(:SET,values)
        end

        #
        # Appends a `INDEXED BY` clause.
        #
        # @param [Field, Symbol] name
        #   The name of the index.
        #
        # @return [self]
        #
        def indexed_by(name,&block)
          clause([:INDEXED, :BY],name,&block)
        end

        #
        # Appends a `NOT INDEXED` clause.
        #
        # @return [self]
        #
        def not_indexed
          clause([:NOT, :INDEXED])
        end
      end
    end
  end
end
