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

require 'ronin/code/sql/emitable'

module Ronin
  module Code
    module SQL
      class Keyword

        include Emitable

        #
        # Creates a new Keyword object with the specified _value_.
        #
        def initialize(value)
          @value = value
        end

        def Keyword.separator
          Keyword.new(';')
        end

        def Keyword.open_paren
          Keyword.new('(')
        end

        def Keyword.close_paren
          Keyword.new(')')
        end

        def Keyword.comma
          Keyword.new(',')
        end

        def emit
          [self]
        end

        def is_separator?
          @value == ';'
        end

        def is_open_paren?
          @value == '('
        end

        def is_close_paren?
          @value == ')'
        end

        def is_comma?
          @value == ','
        end

        #
        # Returns the value of the keyword in String form.
        #
        def to_s
          @value.to_s
        end

      end
    end
  end
end
