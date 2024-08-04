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

require_relative 'emittable'
require_relative 'operators'

module Ronin
  module Code
    module SQL
      #
      # Represents SQL literals.
      #
      # @api semipublic
      #
      class Literal

        include Operators
        include Emittable

        # The literal value.
        #
        # @return [String, Integer, Float, :NULL]
        attr_reader :value

        #
        # Initializes the literal value.
        #
        # @param [String, Integer, Float, :NULL] value
        #   The value for the literal.
        #
        def initialize(value)
          @value = value
        end

      end
    end
  end
end
