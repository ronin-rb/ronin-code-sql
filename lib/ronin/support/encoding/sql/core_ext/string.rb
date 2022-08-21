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

require 'ronin/support/encoding/sql'

class String

  #
  # Escapes an String for SQL.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments.
  #
  # @option kwargs [:single, :double, :tick] :quotes (:single)
  #   Specifies whether to create a single or double quoted string.
  #
  # @return [String]
  #   The escaped String.
  #
  # @raise [ArgumentError]
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
  # @see Ronin::Support::Encoding::SQL.escape
  #
  def sql_escape(**kwargs)
    Ronin::Support::Encoding::SQL.escape(self,**kwargs)
  end

  #
  # Unescapes a SQL String.
  #
  # @return [String]
  #   The unescaped String.
  #
  # @raise [ArgumentError]
  #   The String was not quoted with single, double or tick-mark quotes.
  #
  # @example
  #   "'O''Brian'".sql_unescape
  #   # => "O'Brian"
  #
  # @api public
  #
  # @see Ronin::Support::Encoding::SQL.unescape
  #
  # @since 1.0.0
  #
  def sql_unescape
    Ronin::Support::Encoding::SQL.unescape(self)
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
  # @see Ronin::Support::Encoding::SQL.encode
  #
  def sql_encode
    Ronin::Support::Encoding::SQL.encode(self)
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
  # @see Ronin::Support::Encoding::SQL.decode
  #
  # @api public
  #
  def sql_decode
    Ronin::Support::Encoding::SQL.decode(self)
  end

end
