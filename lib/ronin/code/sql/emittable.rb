#
#--
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
#++
#

require 'ronin/code/emittable'

module Ronin
  module Code
    module SQL
      module Emittable
        include Code::Emittable

        protected

        def emit_token(value)
          value.to_s.split(/\s/).map { |word| Token.new(word) }
        end

        def emit_value(value)
          if value.kind_of?(Statement)
            tokens = []
            
            tokens << Token.open_paren
            tokens += value.emit
            tokens << Token.close_paren

            return tokens
          else
            return super(value)
          end
        end

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
            tokens << emit_value(values[index])
            tokens << Token.new(',')
          end

          tokens << emit_value(values.last)
          return tokens
        end

        #
        # Emits the specified SQL _row_.
        #
        def emit_row(row)
          case row.length
          when 0
            return []
          when 1
            return emit_list(row)
          else
            return [Token.new('(')] + emit_list(row) + [Token.new(')')]
          end
        end

        #
        # Emits the specified _statement_.
        #
        def emit_statement(statement)
          if statement.kind_of?(Statement)
            return statement.emit
          else
            return statement
          end
        end
      end
    end
  end
end
