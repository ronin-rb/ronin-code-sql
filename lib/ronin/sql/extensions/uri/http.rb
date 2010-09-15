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

module URI
  class HTTP < Generic

    #
    # @see Ronin::SQL::Injection.scan
    #
    def sqli_scan(options={})
      Ronin::SQL::Injection.scan(self,options)
    end

    #
    # Attempts to find the first SQL Injection vulnerability in the URL.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @return [Ronin::SQL::Injection, nil]
    #   The first SQL Injection vulnerability found.
    #
    def first_sqli(options={})
      sqli_scan(options).first
    end

    #
    # Determines if the URL is vulnerable to SQL Injection.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @return [Boolean]
    #   Specifies whether the URL is vulnerable to SQL Injection.
    #
    def has_sqli?(options={})
      !(first_sqli.nil?)
    end

    #
    # Attempts to generate SQL Errors from the URL.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @option options [String] :sql ("'")
    #   The SQL to inject.
    #
    # @return [Boolean]
    #   Specifies whether the URL has SQL Errors.
    #
    def sql_errors(options={})
      errors = {}

      return each_query_param do |param,value|
        mesg = Ronin::SQL::Injection.new(self,param).error(options)

        errors[param] = mesg if mesg
      end

      return errors
    end

    #
    # Attempts to generate the first SQL Error from the URL.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @option options [String] :sql ("'")
    #   The SQL to inject.
    #
    # @return [Boolean]
    #   Specifies whether the URL has SQL Errors.
    #
    def sql_error(options={})
      sql_errors(options).values.first
    end

    #
    # Determines if the URL has SQL Errors.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @option options [String] :sql ("'")
    #   The SQL to inject.
    #
    # @return [Boolean]
    #   Specifies whether the URL has SQL Errors.
    #
    def has_sql_errors?(options={})
      !(sql_error(options).nil?)
    end

    #
    # @deprecated Use {#sqli_scan} instead.
    #
    def sql_injections
      sqli_scan
    end

    #
    # @deprecated Use {#first_sqli} instead.
    #
    def sql_injection
      first_sqli
    end

    #
    # @deprecated Use {#has_sqli?} instead.
    #
    def has_sql_injections?
      has_sqli?
    end

  end
end
