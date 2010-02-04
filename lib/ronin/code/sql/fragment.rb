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

require 'ronin/formatting/text'
require 'ronin/formatting/sql'

module Ronin
  module Code
    module SQL
      class Fragment

        # aliased keywords
        ALIASES = {
          :all => '*',
          :eq => '=',
          :neq => '!=',
          :lt => '<',
          :le => '<=',
          :gt => '>',
          :ge => '>='
        }

        # Elements of the fragment
        attr_accessor :elements

        # Controls the casing of keywords
        attr_accessor :case

        # Controls the quoting of strings
        attr_accessor :quotes

        # Controls whether all strings will be hex-escaped
        attr_accessor :hex_escape

        # Controls the amount of parenthesis surrounding lists
        attr_accessor :less_parens

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
          @elements = elements

          @case = options[:case]
          @quotes = options[:quotes]
          @hex_escape = options[:hex_escape]
          @less_parens = options[:less_parens]
        end

        #
        # Appends the given elements to the fragment.
        #
        # @param [Array] elements
        #   The elements to append.
        #
        # @return [Fragment]
        #   The fragment with the elements appended.
        #
        # @since 0.3.0
        #
        def [](*elements)
          @elements += elements
          return self
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
        # Encodes the elements of the fragment into tokens.
        #
        # @param [Hash] options
        #   Additional options to use in the tokenizing process.
        #
        # @return [Array<String>]
        #   The tokens of the fragment.
        #
        # @see Fragment.tokenize
        #
        # @since 0.3.0
        #
        def tokens(options={})
          self.class.tokenize(@elements,options)
        end

        #
        # Encodes the fragment to SQL code.
        #
        # @param [Hash] options
        #   Additional options to use in the encoding process.
        #
        # @return [String]
        #   The encoded SQL.
        #
        # @since 0.3.0
        #
        def to_sql(options={})
          options = {
            :case => @case,
            :quotes => @quotes,
            :hex_escape => @hex_escape,
            :less_parens => @less_parens
          }.merge(options)

          encoded_tokens = tokens(options)

          if options[:spaces] == false
            return tokens.join('/**/')
          else
            return tokens.join(' ')
          end
        end

        #
        # Converts the SQL fragment to SQL code.
        #
        # @return [String]
        #   The encoded SQL.
        #
        # @since 0.3.0
        #
        def to_s
          to_sql()
        end

        #
        # Converts an Array of Ruby primatives into an Array of SQL tokens.
        #
        # @param [Array] expr
        #   The Array of Ruby data to convert into SQL tokens.
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
        # @return [Array<String>]
        #   The SQL tokens.
        #
        # @since 0.3.0
        #
        def self.tokenize(elements,options)
          tokens = []

          elements.each do |element|
            case element
            when Fragment
              tokens += element.tokens(options)
            when Hash
              tokens << wrap_list(element.to_a.map { |name,value|
                name = encode_list([*name],options)
                value = encode_list([*value],options)

                "#{name}=#{value}"
              },options)
            when Array
              tokens << encode_list(element,options)
            when Symbol
              name = (ALIASES[element] || element.to_s)

              tokens << encode_keyword(name,options)
            when String
              tokens << encode_string(element,options)
            when Integer
              tokens << encode_integer(element,options)
            when Float
              tokens << encode_float(element,options)
            when NilClass
              tokens << encode_keyword(:null,options)
            when TrueClass
              tokens << encode_keyword(:true,options)
            when FalseClass
              tokens << encode_keyword(:false,options)
            else
              raise(RuntimeError,"invalid data #{element.inspect} passed to #{self}.tokenize",caller)
            end
          end

          return tokens
        end

        #
        # Encodes the given keyword.
        #
        # @param [Symbol] name
        #   The name of the keyword.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Symbol] :case
        # 
        # @return [String]
        #   The encoded keyword.
        #
        # @since 0.3.0
        #
        def self.encode_keyword(name,options)
          name = name.to_s

          case options[:case]
          when :lower
            name.downcase
          when :upper
            name.upcase
          when :random
            name.random_case
          else
            name
          end
        end

        #
        # Encodes the integer.
        #
        # @param [Integer] integer
        #   The integer to encode.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @return [String]
        #   The encoded integer.
        #
        # @since 0.3.0
        #
        def self.encode_integer(integer,options)
          integer.to_s
        end

        #
        # Encodes the floating point number.
        #
        # @param [Float] float
        #   The floating point number to encode.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @return [String]
        #   The encoded floating point number.
        #
        # @since 0.3.0
        #
        def self.encode_float(float,options)
          float.to_s
        end

        #
        # Encodes the string.
        #
        # @param [String] text
        #   The string to encode.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Boolean] :hex_escape (false)
        #   Specifies whether to hex-escape the string.
        #
        # @return [String]
        #   The encoded string.
        #
        # @since 0.3.0
        #
        def self.encode_string(text,options)
          if options[:hex_escape]
            return encode_keyword(name,options) + "(#{text.sql_encode})"
          end

          return text.dump
        end

        #
        # Wraps a list of tokens in parenthesis.
        #
        # @param [Array<String>] tokens
        #   The tokens to wrap.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Boolean] :less_parens
        #   Specifies whether or not to use parenthesis when wrapping
        #   lists with more than one element.
        #
        # @return [String]
        #   The wrapped comma-separated list.
        #
        # @since 0.3.0
        #
        def self.wrap_list(tokens,options)
          value = case tokens.length
                  when 0
                    '()'
                  when 1
                    tokens.first
                  else
                    value = tokens.join(',')

                    unless options[:less_parens]
                      value = "(#{value})"
                    end
                  end

          return value
        end

        #
        # Encodes the list of elements.
        #
        # @param [Array] elements
        #   The list of elements to encode.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @see wrap_list
        #
        # @since 0.3.0
        #
        def self.encode_list(elements,options)
          wrap_list(tokenize(elements,options),options)
        end

        #
        # Encodes a function call.
        #
        # @param [Symbol] name
        #   The name of the function to be called.
        #
        # @param [Array] arguments
        #   The optional arguments to call the function with.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @since 0.3.0
        #
        def self.encode_function(name,arguments,options)
          encode_keyword(name,options) + encode_list(arguments,options)
        end

      end
    end
  end
end
