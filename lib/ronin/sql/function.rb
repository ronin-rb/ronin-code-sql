#
# Ronin SQL - A Ruby DSL for crafting SQL Injections.
#
# Copyright (c) 2007-2021 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-sql.
#
# ronin-sql is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-sql is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-sql.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/sql/operators'
require 'ronin/sql/emittable'

module Ronin
  module SQL
    #
    # Represents a SQL function call.
    #
    # @api semipublic
    #
    class Function < Struct.new(:name,:arguments)

      include Operators
      include Emittable

      #
      # Creates a new Function object.
      #
      # @param [Symbol] name
      #   The name of the function.
      #
      # @param [Array] arguments
      #   The arguments of the function.
      #
      def initialize(name,*arguments)
        super(name,arguments)
      end

    end
  end
end
