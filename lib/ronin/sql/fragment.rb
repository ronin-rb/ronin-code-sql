#
# Ronin SQL - A Ruby DSL for crafting SQL Injections.
#
# Copyright (c) 2007-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/sql/formattable'

module Ronin
  module SQL
    class Fragment

      include Formattable

      # Elements of the fragment
      attr_accessor :elements

      #
      # Creates a new Fragment object.
      #
      # @param [Array] elements
      #   Initial elements of the fragment.
      #
      # @since 0.3.0
      #
      def initialize(elements=[])
        @elements = elements
      end

      #
      # Appends a single element.
      #
      # @param [Object] element
      #   The element to append.
      #
      # @return [Fragment]
      #   The fragment with the appended element.
      #
      # @since 0.3.0
      #
      def <<(element)
        @elements << element
        return self
      end

      #
      # Converts the fragment to an Array.
      #
      # @return [Array]
      #   The elements of the fragment.
      #
      # @since 0.3.0
      #
      def to_a
        @elements
      end

      #
      # Formats the fragment.
      #
      # @param [Formatter] formatter
      #   The formatter to use.
      #
      # @return [String]
      #   The formatted SQL.
      #
      def format(formatter)
        formatter.format_elements(*@elements)
      end

    end
  end
end
