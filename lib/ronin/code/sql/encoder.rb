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
      module Encoder
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

        # Default case preference
        DEFAULT_CASE = :lower

        # Default quoting preference
        DEFAULT_QUOTES = :single

        # Default parenthesis preference
        DEFAULT_PARENS = :more

        #
        # Initializes the encoder.
        #
        # @param [Hash] options
        #   Encoding options.
        #
        # @option options [Symbol] :case (DEFAULT_CASE)
        #   Controls the case of keywords. May be either `:lower`,
        #   `:upper` or `:random`
        #
        # @option options [Symbol] :quotes (DEFAULT_QUOTES)
        #   Controls the quoting style of strings. May be either `:single`
        #   or `:double`.
        #
        # @option options [Boolean] :hex_escape
        #   Forces all Strings to be hex-escaped.
        #
        # @option options [Symbol] :parens (DEFAULT_PARENS)
        #   Reduces the amount of parenthesis when tokenizing lists.
        #   May be either `:less`, `:more`.
        #
        # @since 0.3.0
        #
        def initialize(options={})
          @options = {
            :case => DEFAULT_CASE,
            :quotes => DEFAULT_QUOTES,
            :parens => DEFAULT_PARENS
          }.merge(options)
        end

        #
        # The encoding options.
        #
        # @return [Hash]
        #   The encoding options.
        #
        # @since 0.3.0
        #
        def options
          @options
        end

        #
        # Default encoder method to create SQL code.
        #
        # @return [String]
        #   The encoded SQL.
        #
        # @since 0.3.0
        #
        def to_sql
          encoded_tokens = tokens()

          if options[:spaces] == false
            return tokens.join('/**/')
          else
            return tokens.join(' ')
          end
        end

        alias to_s to_sql

        protected

        #
        # Default method to return tokens for encoding.
        #
        # @return [Array<String>]
        #   The tokens to be encoded.
        #
        # @since 0.3.0
        #
        def tokens
          []
        end

        #
        # Converts an Array of Ruby primatives into an Array of SQL tokens.
        #
        # @param [Array] expr
        #   The Array of Ruby data to convert into SQL tokens.
        #
        # @return [Array<String>]
        #   The SQL tokens.
        #
        # @since 0.3.0
        #
        def encode(*elements)
          tokens = []

          elements.each do |element|
            case element
            when Encoder
              tokens << element.to_sql
            when Hash
              tokens << encode_hash(element)
            when Array
              tokens << encode_list(*element)
            when Symbol
              name = (ALIASES[element] || element.to_s)

              tokens << encode_keyword(name)
            when String
              tokens << encode_string(element)
            when Integer
              tokens << encode_integer(element)
            when Float
              tokens << encode_float(element)
            when NilClass
              tokens << encode_null()
            when TrueClass, FalseClass
              tokens << encode_boolean(element)
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
        # @return [String]
        #   The encoded keyword.
        #
        # @since 0.3.0
        #
        def encode_keyword(name)
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
        # Encodes a NULL keyword.
        #
        # @return [String]
        #   The encoded SQL NULL value.
        #
        # @since 0.3.0
        #
        def encode_null
          encode_keyword(:null)
        end

        #
        # Encodes a Boolean value.
        #
        # @param [Boolean] bool
        #   The Boolean value.
        #
        # @return [String]
        #   The encoded SQL Boolean value.
        #
        # @since 0.3.0
        #
        def encode_boolean(bool)
          if bool == true
            encode_keyword(:true)
          else
            encode_keyword(:false)
          end
        end

        #
        # Encodes the integer.
        #
        # @param [Integer] integer
        #   The integer to encode.
        #
        # @return [String]
        #   The encoded integer.
        #
        # @since 0.3.0
        #
        def encode_integer(integer)
          integer.to_s
        end

        #
        # Encodes the floating point number.
        #
        # @param [Float] float
        #   The floating point number to encode.
        #
        # @return [String]
        #   The encoded floating point number.
        #
        # @since 0.3.0
        #
        def encode_float(float)
          float.to_s
        end

        #
        # Encodes the string.
        #
        # @param [String] text
        #   The string to encode.
        #
        # @return [String]
        #   The encoded string.
        #
        # @since 0.3.0
        #
        def encode_string(text)
          if options[:hex_escape]
            return encode_keyword(name) + "(#{text.sql_encode})"
          end

          return text.dump
        end

        #
        # Wraps a list of tokens in parenthesis.
        #
        # @param [Array<String>] tokens
        #   The tokens to wrap.
        #
        # @return [String]
        #   The wrapped comma-separated list.
        #
        # @since 0.3.0
        #
        def wrap_list(tokens)
          value = case tokens.length
                  when 0
                    ''
                  when 1
                    tokens.first
                  else
                    tokens.join(',')
                  end

          return '()' if value.empty?

          if options[:parens] == :more
            value = "(#{value})"
          end

          return value
        end

        #
        # Encodes the list of elements.
        #
        # @param [Array] elements
        #   The list of elements to encode.
        #
        # @see wrap_list
        #
        # @since 0.3.0
        #
        def encode_list(*elements)
          wrap_list(encode(*elements))
        end

        #
        # Encodes a Hash.
        #
        # @param [Hash] hash
        #   The hash to be encoded.
        #
        # @return [String]
        #   The encoded Hash.
        #
        # @since 0.3.0
        #
        def encode_hash(hash)
          wrap_list(hash.to_a.map { |name,value|
            name = encode_list(name)
            value = encode_list(value)

            "#{name}=#{value}"
          })
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
        # @since 0.3.0
        #
        def encode_function(name,arguments)
          encode_keyword(name) + encode_list(*arguments)
        end
      end
    end
  end
end
