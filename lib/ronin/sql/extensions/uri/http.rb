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

require 'ronin/sql/sql'
require 'ronin/network/http'

require 'uri'

module URI
  class HTTP < Generic

    #
    # Tests the +query_params+ of the HTTP URL with the given _options_ for
    # SQL errors.
    #
    # _options_ may contain the following keys:
    # <tt>:injection</tt>:: The SQL injection to use. Defaults to
    #                       <tt>"'"</tt>.
    # <tt>:types</tt>:: A list of error types to test for. If not specified
    #                   all the error patterns in ERROR_PATTERNS will be
    #                   tested.
    #
    def sql_errors(options={})
      injection = (options[:injection] || "'")

      return test_query_params(injection,options) do |param,injection_url|
        if options[:method] == :post
          body = Net.http_post_body(options.merge(:url => injection_url))
        else
          body = Net.http_get_body(options.merge(:url => injection_url))
        end

        Ronin::SQL.error(body,options)
      end
    end

    #
    # Tests each +query_params+ of the HTTP URI with the given _options_ for
    # SQL errors.
    #
    # _options_ may contain the following keys:
    # <tt>:injection</tt>:: The SQL injection to use. Defaults to
    #                       <tt>"'"</tt>.
    # <tt>:types</tt>:: A list of error types to test for. If not specified
    #                   all the error patterns in ERROR_PATTERNS will be
    #                   tested.
    #
    def has_sql_errors?(options={})
      !(sql_errors(options).empty?)
    end

  end
end
