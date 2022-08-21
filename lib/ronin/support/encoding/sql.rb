#
# Ronin SQL - A Ruby DSL for crafting SQL Injections.
#
# Copyright (c) 2007-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-sql.
#
# ronin-sql is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-sql is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-sql.  If not, see <https://www.gnu.org/licenses/>.
#

module Ronin
  module Support
    class Encoding < ::Encoding
      module SQL
        # The quote styles and their quote characters.
        QUOTE_STYLES = {
          single: "'",
          double: '"',
          tick:   '`'
        }

        #
        # Escapes a String for SQL.
        #
        # @param [String] data
        #   The String to SQL escape.
        #
        # @param [:single, :double, :tick] quotes
        #   Specifies whether to create a single or double quoted string.
        #
        # @return [String]
        #   The SQL escaped string.
        #
        # @raise [ArgumentError]
        #   The quotes argument was neither `:single`, `:double` nor `:tick`.
        #
        def self.escape(data, quotes: :single)
          char = QUOTE_STYLES.fetch(quotes) do
                   raise(ArgumentError,"invalid quoting style #{quotes.inspect}")
                 end

          escaped = data.gsub(char,char * 2)

          return "#{char}#{escaped}#{char}"
        end

        #
        # Unescapes a SQL String.
        #
        # @param [String] data
        #   The SQL string to unescape.
        #
        # @return [String]
        #   The unescaped SQL string value.
        #
        # @raise [ArgumentError]
        #   The String was not quoted with single, double or tick-mark quotes.
        #
        def self.unescape(data)
          char = if    (data[0] == "'" && data[-1] == "'") then "'"
                 elsif (data[0] == '"' && data[-1] == '"') then '"'
                 elsif (data[0] == '`' && data[-1] == '`') then '`'
                 else
                   raise(ArgumentError,"#{data.inspect} is not properly quoted")
                 end

          return data[1..-2].gsub(char * 2,char)
        end

        #
        # Returns the SQL hex-string encoded form of the String.
        #
        # @param [String] data
        #
        # @return [String]
        #
        def self.encode(data)
          return '' if data.empty?

          hex_string = '0x'

          data.each_byte do |b|
            hex_string << ('%.2x' % b)
          end

          return hex_string
        end

        #
        # Returns the SQL decoded form of the String.
        #
        # @param [String] data
        #   The SQL string to decode.
        #
        # @return [String]
        #   The decoded String.
        #
        def self.decode(data)
          if (data =~ /^[0-9a-fA-F]{2,}$/ && (data.length % 2 == 0))
            raw = String.new

            data.scan(/../) do |hex_char|
              raw << hex_char.to_i(16)
            end

            return raw
          else
            unescape(data)
          end
        end
      end
    end
  end
end

require 'ronin/support/encoding/sql/core_ext'
