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

module Ronin
  module Code
    module SQL
      class Function

        include Encoder

        # The name of the function
        attr_reader :name

        # The arguments of the function
        attr_reader :arguments

        #
        # Creates a new Function object.
        #
        # @param [Symbol] name
        #   The name of the function.
        #
        # @param [Array] arguments
        #   The arguments of the function.
        #
        # @param [Hash] options
        #   Encoding options.
        #
        # @since 0.3.0
        #
        def initialize(name,arguments=[],options={})
          super(options)

          @name = name
          @arguments = arguments
        end

        #
        # Encodes the function into SQL tokens.
        #
        # @return [Array<String>]
        #   The token representation of the function.
        #
        # @since 0.3.0
        #
        def tokens
          [encode_function(@name,@arguments)]
        end

      end
    end
  end
end
