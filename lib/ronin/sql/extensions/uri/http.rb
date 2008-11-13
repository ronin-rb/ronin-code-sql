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

require 'ronin/sql/injection'
require 'ronin/chars/extensions'

require 'uri'

module URI
  class HTTP < Generic

    #
    # Tests the +query_params+ of the HTTP URL with the given _options_ for
    # SQL errors.
    #
    # _options_ may contain the following keys:
    # <tt>:sql</tt>:: The SQL injection to use. Defaults to <tt>"'"</tt>.
    #
    def sql_errors(options={})
      options = {:sql => "'"}.merge(options)

      return test_query_params(sql,options) do |param,test_url|
        SQL::Injection.new(test_url,param).error(options)
      end
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
    def sql_injections(options={})
      integer_tests = [
        {:escape => 1},
        {:escape => 1, :close_parenthesis => true}
      ]

      string_tests = [
        {:escape => '1', :close_string => true},
        {:escape => '1', :close_string => true, :close_parenthesis => true}
      ]

      return test_query_params(sql,options) do |param,test_url|
        original_value = self.query_param[param]

        if (original_value && original_value.is_numeric?)
          tests = integer_tests + string_tests
        else
          tests = string_tests + integer_tests
        end

        injections = tests.map do |test|
          SQL::Injection.new(test_url,param,options.merge(test))
        end
        
        injections.find { |injection| injection.vulnerable?(options) }
      end
    end

  end
end
