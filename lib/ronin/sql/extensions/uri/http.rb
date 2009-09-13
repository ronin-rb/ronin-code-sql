#
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
#

require 'ronin/sql/injection'
require 'ronin/scanners/scanner'
require 'ronin/extensions/uri/http'

module URI
  class HTTP < Generic

    include Ronin::Scanners::Scanner

    #
    # Tests the +query_params+ of the HTTP URL with the given _options_ for
    # SQL errors.
    #
    # _options_ may contain the following keys:
    # <tt>:sql</tt>:: The SQL injection to use. Defaults to <tt>"'"</tt>.
    #
    def sql_errors(options={})
      errors = {}

      return each_query_param do |param,value|
        mesg = Ronin::SQL::Injection.new(self,param).error(options)

        errors[param] = mesg if mesg
      end

      return errors
    end

    def sql_error(options={})
      sql_errors(options).values.first
    end

    #
    # Returns +true+ if any of the +query_params+ of the HTTP URI return
    # SQL errors using the given _options_, returns +false+ otherwise.
    #
    # _options_ may contain the following keys:
    # <tt>:sql</tt>:: The SQL injection to use. Defaults to <tt>"'"</tt>.
    #
    def has_sql_errors?(options={})
      !(sql_errors(options).empty?)
    end

    #
    # Tests the +query_params+ of the HTTP URL with the given _options_ for
    # blind SQL injections.
    #
    scanner(:sqli) do |url,results,options|
      url.each_query_param do |param,value|
        integer_tests = [
          {:escape => value},
          {:escape => value, :close_parenthesis => true}
        ]

        string_tests = [
          {:escape => value, :close_string => true},
          {:escape => value, :close_string => true, :close_parenthesis => true}
        ]

        if (value && value =~ /^[0-9]+$/)
          # if the param value is numeric, we should try escaping a
          # numeric value first.
          tests = integer_tests + string_tests
        else
          # if the param value is a string, we should try escaping a
          # string value first.
          tests = string_tests + integer_tests
        end

        tests.each do |test|
          inj = Ronin::SQL::Injection.new(url,param,options.merge(test))

          if inj.vulnerable?(options)
            results.call(inj)
            break
          end
        end
      end
    end

    alias sql_injections sqli_scan
    alias sql_injection first_sqli
    alias has_sql_injections? has_sqli?

  end
end
