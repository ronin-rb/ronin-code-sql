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

require 'ronin/sql/literal'

module Ronin
  module SQL
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
      # @return [Literal<Integer>]
      #   The Integer literal.
      #
      def int(value)
        Literal.new(value.to_i)
      end

      #
      # Creates an Float literal.
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
      # @return [Literal<String>]
      #   The String literal.
      #
      def string(value)
        Literal.new(value.to_s)
      end
    end
  end
end