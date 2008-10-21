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

module Ronin
  module Code
    module SQL
      module Emitable
        #
        # Default emit method which simply returns +nil+.
        #
        def emit
          []
        end

        protected

        def keyword(value)
          Keyword.new(value)
        end

        #
        # Emits the specified _value_ if _value_ is a kind of Expr object,
        # otherwise _value_ will be returned.
        #
        def emit_value(value)
          if value.kind_of?(Emitable)
            return value.emit
          else
            return [value]
          end
        end

        #
        # Emits each of the specified _valueis_.
        #
        def emit_values(values)
          tokens = []

          values.each { |value| tokens += emit_value(value) }

          return tokens
        end

        #
        # Emits the comma separated list of the specified _values_.
        #
        def emit_list(values)
          tokens = []

          (values.length - 1).times do |index|
            tokens << values[i]
            tokens << Keyword.new(',')
          end

          tokens << values.last
          return tokens
        end

        #
        # Emits the specified SQL _row_.
        #
        def emit_row(row)
          [Keyword.new('(')] + emit_list(row) + [Keyword.new(')')]
        end
      end
    end
  end
end
