# frozen_string_literal: true
#
# ronin-code-sql - A Ruby DSL for crafting SQL Injections.
#
# Copyright (c) 2007-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/code/sql/emittable'
require 'ronin/code/sql/operators'

module Ronin
  module Code
    module SQL
      #
      # Represents SQL literals.
      #
      # @api semipublic
      #
      class Literal < Struct.new(:value)

        include Operators
        include Emittable

      end
    end
  end
end
