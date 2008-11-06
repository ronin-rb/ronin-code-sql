#
#--
# Ronin SQL - A Ronin library providing support for SQL related security
# tasks.
#
# Copyright (c) 2007-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/sql/error'
require 'ronin/extensions/uri'

module Ronin
  module SQL
    #
    # Tests whether the _body_ contains an SQL error message using the
    # given _options_.
    #
    # _options_ may contain the following keys:
    # <tt>:dialect</tt>:: The SQL dialect whos error messages to test for.
    # <tt>:types</tt>:: A list of error pattern types to test for.
    #
    def SQL.error(body,options={})
      if options[:dialect]
        patterns = Error.patterns_for_dialect(options[:dialect])
      elsif options[:types]
        patterns = Error.patterns_for(*options[:types])
      else
        patterns = Error.patterns.values
      end

      patterns.each do |pattern|
        if (message = pattern.match(body))
          return message
        end
      end

      return nil
    end

    #
    # Returns +true+ if the specified _body_ using the given _options_
    # contains an SQL error, returns +false+ otherwise.
    #
    # _options_ may contain the following keys:
    # <tt>:dialect</tt>:: The SQL dialect whos error messages to test for.
    # <tt>:types</tt>:: A list of error pattern types to test for.
    #
    def SQL.has_error?(body,options={})
      !(SQL.error(body,options).nil?)
    end
  end
end
