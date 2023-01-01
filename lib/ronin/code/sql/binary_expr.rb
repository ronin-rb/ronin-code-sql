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

require 'ronin/code/sql/operators'
require 'ronin/code/sql/emittable'

module Ronin
  module Code
    module SQL
      #
      # Represents a binary expression in SQL.
      #
      # @api semipublic
      #
      class BinaryExpr < Struct.new(:left,:operator,:right)

        include Operators
        include Emittable

        #
        # Converts the binary expression to SQL.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {Emitter#initialize}.
        #
        # @return [String]
        #   The emitted SQL expression.
        #
        def to_sql(**kwargs)
          emitter(**kwargs).emit_expression(self)
        end

      end
    end
  end
end
