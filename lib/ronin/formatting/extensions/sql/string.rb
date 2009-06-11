#
#--
# Ronin SQL - A Ronin library providing support for SQL related security
# tasks.
#
# Copyright (c) 2007-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#++
#

class String

  #
  # Returns the SQL hex-string encoded form of the String.
  #
  #   "/etc/passwd".sql_encode
  #   # => "0x2f6574632f706173737764"
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
  #   "'Conan O''Brian'".sql_decode
  #   # => "Conan O'Brian"
  #
  #  "0x2f6574632f706173737764".sql_decode
  #  # => "/etc/passwd"
  #
  def sql_decode
    if ((self[0...2] == '0x') && (length % 2 == 0))
      raw = ''

      self[2..-1].scan(/[0-9a-fA-F]{2}/).each do |hex_char|
        raw << hex_char.hex.chr
      end

      return raw
    elsif (self[0..0] == "'" && self[-1..-1] == "'")
      self[1..-2].gsub(/\\'/,"'").gsub(/''/,"'")
    else
      return self
    end
  end

end
