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

require 'ronin/extensions/uri'
require 'ronin/network/http'

module Ronin
  module SQL

    # SQL error patterns
    ERROR_PATTERNS = {
      # sourced from sqid (http://sqid.rubyforge.org/).
      :ms_sql => /Microsoft OLE DB Provider for (SQL Server|ODBC Drivers.*\[Microsoft\]\[ODBC (SQL Server|Access) Driver\])/,
      :ms_access => /\[Microsoft\]\[ODBC Microsoft Access Driver\] Syntax error/,
      :ms_jetdb => /Microsoft JET Database Engine/,
      :ms_adodb => /ADODB.Command.*error/,
      :asp_net => /Server Error.*System\.Data\.OleDb\.OleDbException/,
      :my_sql => /(Warning.*(supplied argument is not a valid MySQL result|mysql_.*\(\))|You have an error in your SQL syntax.*(on|at) line)/,
      :php => /(Warning.*failed to open stream|Fatal Error.*(on|at) line)/,
      :oracle => /ORA-[0-9][0-9][0-9][0-9]/,
      :jdbc => /Invalid SQL statement or JDBC/,
      :java_servlet => /javax\.servlet\.ServletException/,
      :apache_tomcat => /org\.apache\.jasper\.JasperException/,
      :vb_runtime => /Microsoft VBScript runtime/,
      :vb_asp => /Type mismatch/
    }

    #
    # Tests whether the _body_ contains an SQL error message using the
    # given _options_.
    #
    # _options_ may contain the following keys:
    # <tt>:types</tt>:: A list of error types to test for. If not specified
    #                   all the error patterns in ERROR_PATTERNS will be
    #                   tested.
    #
    def SQL.error(body,options={})
      patterns = (options[:types] || ERROR_PATTERNS.keys)

      patterns.each do |type|
        match = ERROR_PATTERNS[type].match(body)

        return {:type => type, :message => match[0]} if match
      end

      return {}
    end

    #
    # Returns the type of SQL error found in _body_ using the given
    # _options_, returns +nil+ if the _body_ does not contain any errors.
    #
    # _options_ may contain the following keys:
    # <tt>:types</tt>:: A list of error types to test for. If not specified
    #                   all the error patterns in ERROR_PATTERNS will be
    #                   tested.
    #
    def SQL.error_type(body,options={})
      SQL.error(body,options)[:type]
    end

    #
    # Returns the SQL error message found in the _body_ using the given
    # _options_, returns +nil+ if the _body_ does not contain any errors.
    #
    # _options_ may contain the following keys:
    # <tt>:types</tt>:: A list of error types to test for. If not specified
    #                   all the error patterns in ERROR_PATTERNS will be
    #                   tested.
    #
    def SQL.error_message(body,options={})
      SQL.error(body,options)[:message]
    end

    #
    # Returns +true+ if the specified _body_ using the given _options_
    # contains an SQL error, returns +false+ otherwise.
    #
    # _options_ may contain the following keys:
    # <tt>:types</tt>:: A list of error types to test for. If not specified
    #                   all the error patterns in ERROR_PATTERNS will be
    #                   tested.
    #
    def SQL.has_error?(body,options={})
      !(SQL.error(body,options).empty?)
    end

    #
    # Tests each +query_params+ from the specified _url_ using the
    # specified _injection_ and the given _options_.
    #
    def SQL.test_url(url,injection,options={},&block)
      url = URI(url.to_s)

      return url.test_query_params(injection,options) do |injection_url|
        block.call(Net.http_get(options.merge(:url => injection_url)))
      end
    end

    #
    # Tests the +query_params+ of the specified _url_ with the given
    # _options_ for SQL errors.
    #
    # _options_ may contain the following keys:
    # <tt>:injection</tt>:: The SQL injection to use. Defaults to
    #                       <tt>"'"</tt>.
    # <tt>:types</tt>:: A list of error types to test for. If not specified
    #                   all the error patterns in ERROR_PATTERNS will be
    #                   tested.
    #
    def SQL.url_errors(url,options={})
      injection = (options[:injection] || "'")

      SQL.test_url(url,injection,options) do |page|
        SQL.error(page.body,options)
      end
    end

    def SQL.url_error_types(url,options={})
      types = {}

      SQL.url_errors(url,options).each do |param,error|
        types[param] = error[:type] if error[:type]
      end

      return types
    end

    def SQL.url_error_messages(url,options={})
      types = {}

      SQL.url_errors(url,options).each do |param,error|
        types[param] = error[:message] if error[:message]
      end

      return types
    end

    def SQL.url_has_errors?(url,options={})
      SQL.url_errors(url,options).each_value do |error|
        return true unless error.empty?
      end

      return false
    end

    #
    # Tests each +query_params+ from the specified _url_ with the given
    # _options_ for SQL errors.
    #
    # _options_ may contain the following keys:
    # <tt>:injection</tt>:: The SQL injection to use. Defaults to
    #                       <tt>"'"</tt>.
    # <tt>:types</tt>:: A list of error types to test for. If not specified
    #                   all the error patterns in ERROR_PATTERNS will be
    #                   tested.
    #
    def SQL.test_url_for_errors(url,options={})
      results = {}

      SQL.url_errors(url,options).each do |param,error|
        results[param] = true unless error.empty?
      end

      return results
    end
  end
end
