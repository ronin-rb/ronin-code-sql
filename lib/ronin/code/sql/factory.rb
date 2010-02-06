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

require 'ronin/code/sql/fragment'
require 'ronin/code/sql/function'

module Ronin
  module Code
    module SQL
      class Factory

        # Controls the casing of keywords
        attr_accessor :case

        # Controls the quoting of strings
        attr_accessor :quotes

        # Controls whether all strings will be hex-escaped
        attr_accessor :hex_escape

        # Controls the amount of parenthesis surrounding lists
        attr_accessor :parens

        #
        # Creates a new SQL Encoder object.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Symbol] :case (Encoder::DEFAULT_CASE)
        #   Controls the case of keywords. May be either `:none`, `:lower`,
        #   `:upper` or `:random`
        #
        # @option options [Symbol] :quotes (Encoder::DEFAULT_QUOTE)
        #   Controls the quoting style of strings. May be either `:single`
        #   or `:double`.
        #
        # @option options [Boolean] :hex_escape (false)
        #   Forces all Strings to be hex-escaped.
        #
        # @option options [Symbol] :parens (Encoder::DEFAULT_PARENS)
        #   Reduces the amount of parenthesis when tokenizing lists.
        #   May be either `:less`, `:more`.
        #
        # @since 0.3.0
        #
        def initialize(options={})
          @case = (options[:case] || Encoder::DEFAULT_CASE)
          @quotes = (options[:quotes] || Encoder::DEFAULT_QUOTES)
          @hex_escape = (options[:hex_escape] || false)
          @less_parens = (options[:parens] || Encoder::DEFAULT_PARENS)
        end

        #
        # Creates a new Fragment object.
        #
        # @param [Array] elements
        #   The elements to populate the fragment with.
        #
        # @return [Fragment]
        #   The new fragment object.
        #
        # @since 0.3.0
        #
        def [](*elements)
          Fragment.new(elements,self.options)
        end

        #
        # The options of the encoder.
        #
        # @return [Hash]
        #   The hash of options for the encoder.
        #
        # @since 0.3.0
        #
        def options
          {
            :case => @case,
            :quotes => @quotes,
            :hex_escape => @hex_escape,
            :less_parens => @less_parens
          }
        end

        protected

        #
        # Transparently creates new Function objects.
        #
        # @param [Symbol] name
        #   The name of the SQL function that will be called.
        #
        # @param [Array] arguments
        #   Additional arguments for the SQL function.
        #
        # @return [Function]
        #   The new SQL function call.
        #
        # @since 0.3.0
        #
        def method_missing(name,*arguments,&block)
          unless block
            return Function.new(name,arguments,self.options)
          end

          return super(name,*arguments,&block)
        end

      end
    end
  end
end
