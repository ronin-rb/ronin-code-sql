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

class String

  #
  # Escapes an String for SQL.
  #
  # @param [:single, :double, :tick] quotes (:single)
  #   Specifies whether to create a single or double quoted string.
  #
  # @return [String]
  #   The escaped String.
  #
  # @raise [TypeError]
  #   The quotes argument was neither `:single`, `:double` nor `:tick`.
  #
  # @example
  #   "O'Brian".sql_escape
  #   # => "'O''Brian'"
  #
  # @example Encode with double-quotes:
  #   "O'Brian".sql_escape(:double)
  #   # => "\"O'Brian\""
  #
  # @api public
  #
  def sql_escape(quotes=:single)
    char = case quotes
           when :single then "'"
           when :double then '"'
           when :tick   then '`'
           else
             raise(ArgumentError,"invalid quoting style #{quotes.inspect}")
           end

    return char + gsub(char,char * 2) + char
  end

  #
  # Unescapes a SQL String.
  #
  # @return [String]
  #   The unescaped String.
  #
  # @raise
  #   The String was not quoted with single, double or tick-mark quotes.
  #
  # @example
  #   "'O''Brian'".sql_unescape
  #   # => "O'Brian"
  #
  # @api public
  #
  # @since 1.0.0
  #
  def sql_unescape
    char = if    (self[0] == "'" && self[-1] == "'") then "'"
           elsif (self[0] == '"' && self[-1] == '"') then '"'
           elsif (self[0] == '`' && self[-1] == '`') then '`'
           else
             raise(TypeError,"#{self.inspect} is not properly quoted")
           end

    return self[1..-2].gsub(char * 2,char)
  end

  #
  # Returns the SQL hex-string encoded form of the String.
  #
  # @example
  #   "/etc/passwd".sql_encode
  #   # => "0x2f6574632f706173737764"
  #
  # @api public
  #
  def sql_encode
    return '' if empty?

    hex_string = '0x'

    each_byte do |b|
      hex_string << ('%.2x' % b)
    end

    return hex_string
  end

  #
  # Returns the SQL decoded form of the String.
  #
  # @example
  #   "'Conan O''Brian'".sql_decode
  #   # => "Conan O'Brian"
  #
  # @example
  #  "2f6574632f706173737764".sql_decode
  #  # => "/etc/passwd"
  #
  # @raise
  #   The String is neither hex encoded or SQL escaped.
  #
  # @see #sql_unescape
  #
  # @api public
  #
  def sql_decode
    if (self =~ /^[0-9a-fA-F]{2,}$/ && (length % 2 == 0))
      raw = ''

      scan(/../) do |hex_char|
        raw << hex_char.to_i(16)
      end

      return raw
    else
      sql_unescape
    end
  end

end
