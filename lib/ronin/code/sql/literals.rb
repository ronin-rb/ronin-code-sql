# frozen_string_literal: true
#
# ronin-code-sql - A Ruby DSL for crafting SQL Injections.
#
# Copyright (c) 2007-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/code/sql/literal'

module Ronin
  module Code
    module SQL
      #
      # Methods for creating SQL {Literals Literal}.
      #
      # @api public
      #
      module Literals
        #
        # Creates a `NULL` literal.
        #
        # @return [Literal]
        #   The `NULL` literal.
        #
        def null
          Literal.new(:NULL)
        end

        #
        # Creates an Integer literal.
        #
        # @param [String, Numeric] value
        #   The value to convert to an Integer.
        #
        # @return [Literal<Integer>]
        #   The Integer literal.
        #
        def int(value)
          Literal.new(value.to_i)
        end

        #
        # Creates an Float literal.
        #
        # @param [String, Numeric] value
        #   The value to convert to a Float.
        #
        # @return [Literal<Float>]
        #   The Float literal.
        #
        def float(value)
          Literal.new(value.to_f)
        end

        #
        # Creates an String literal.
        #
        # @param [String, Numeric] value
        #   The value to convert to a String.
        #
        # @return [Literal<String>]
        #   The String literal.
        #
        def string(value)
          Literal.new(value.to_s)
        end
      end
    end
  end
end
