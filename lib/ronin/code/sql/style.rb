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
      module Style
        # Default case preference
        DEFAULT_CASE = :none

        # Default quoting preference
        DEFAULT_QUOTES = :single

        # Default parenthesis preference
        DEFAULT_PARENS = :more

        # Controls the casing of keywords
        attr_accessor :case

        # Controls the quoting of strings
        attr_accessor :quotes

        # Controls whether all strings will be hex-escaped
        attr_accessor :hex_escape

        # Controls the amount of parenthesis surrounding lists
        attr_accessor :parens
        
        # Controls whether spaces are used to separate keywords
        attr_accessor :spaces

        #
        # Sets the style options.
        #
        # @param [Hash] options
        #   Style options.
        #
        # @option options [Symbol] :case (DEFAULT_CASE)
        #   Controls the case of keywords. May be either `:none`, `:lower`,
        #   `:upper` or `:random`
        #
        # @option options [Symbol] :quotes (DEFAULT_QUOTES)
        #   Controls the quoting style of strings. May be either `:single`
        #   or `:double`.
        #
        # @option options [Boolean] :hex_escape (false)
        #   Forces all Strings to be hex-escaped.
        #
        # @option options [Symbol] :parens (DEFAULT_PARENS)
        #   Reduces the amount of parenthesis when tokenizing lists.
        #   May be either `:less`, `:more`.
        #
        # @option options [Boolean] :spaces (true)
        #   Controls whether spaces are used to separate keywords,
        #   or other kinds of white-space.
        #
        # @since 0.3.0
        #
        def initialize(options={})
          @case = (options[:case] || DEFAULT_CASE)
          @quotes = (options[:quotes] || DEFAULT_QUOTES)
          @hex_escape = (options[:hex_escape] || false)
          @parens = (options[:parens] || DEFAULT_PARENS)
          @spaces = true

          if options.has_key?(:spaces)
            @spaces = options[:spaces]
          end
        end
      end
    end
  end
end
