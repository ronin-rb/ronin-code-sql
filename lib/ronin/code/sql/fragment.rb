#
# Ronin SQL - A Ronin library providing support for SQL related security
# tasks.
#
# Copyright (c) 2007-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/code/sql/encoder'
require 'ronin/formatting/text'
require 'ronin/formatting/sql'

module Ronin
  module Code
    module SQL
      class Fragment

        include Encoder

        # Elements of the fragment
        attr_accessor :elements

        #
        # Creates a new Fragment object.
        #
        # @param [Array] elements
        #   Initial elements of the fragment.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Symbol] :case
        #   Controls the case of keywords. May be either `:lower`,
        #   `:upper` or `:random`
        #
        # @option options [Symbol] :quotes
        #   Controls the quoting style of strings. May be either `:single`
        #   or `:double`.
        #
        # @option options [Boolean] :hex_escape
        #   Forces all Strings to be hex-escaped.
        #
        # @option options [Boolean] :less_parens
        #   Reduces the amount of parenthesis when tokenizing lists.
        #
        # @since 0.3.0
        #
        def initialize(elements=[],options={})
          super(options)

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

        protected

        #
        # Encodes the elements of the fragment into SQL tokens.
        #
        # @return [Array<String>]
        #   The token representation of the fragment.
        #
        # @since 0.3.0
        #
        def tokens
          encode(*@elements)
        end

      end
    end
  end
end
