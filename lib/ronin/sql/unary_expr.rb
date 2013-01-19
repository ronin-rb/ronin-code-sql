#
# Ronin SQL - A Ruby DSL for crafting SQL Injections.
#
# Copyright (c) 2007-2013 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/sql/emittable'

module Ronin
  module SQL
    #
    # Represents a unary-expression in SQL.
    #
    class UnaryExpr < Struct.new(:operator,:operand)

      include Emittable

      #
      # Converts the binary expression to SQL.
      #
      # @param [Hash] options
      #   Additional options for {Emitter#initialize}.
      #
      # @return [String]
      #   The emitted SQL expression.
      #
      def to_sql(options={})
        emitter(options).emit_expression(self)
      end

    end
  end
end
