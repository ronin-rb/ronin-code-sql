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

require 'ronin/sql/error'
require 'ronin/code/sql'
require 'ronin/network/mixins/http'
require 'ronin/web/extensions/nokogiri'
require 'ronin/web/spider'

require 'parameters'
require 'uri/query_params'
require 'nokogiri'

module Ronin
  module SQL
    class Injection

      include Parameters
      include Network::Mixins::HTTP

      # The URL to inject upon
      attr_reader :url

      # The URL query param to inject into
      attr_reader :param

      # Options for crafting SQL injections
      attr_reader :sql_options

      # HTTP request method (either :get or :post)
      parameter :http_method,
                :default => :get,
                :description => 'HTTP request method to use'

      #
      # Creates a new Injection object with the specified _url_, _param_
      # to inject upon and the given _options_ which will be used
      # for crafting SQL injections.
      #
      def initialize(url,param,options={})
        super()

        @url = url
        @param = param
        @sql_options = options
      end

      #
      # Scans the URL for SQL Injection vulnerabilities.
      #
      # @param [URI::HTTP, String] url
      #   The URL to scan.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @yield [sqli]
      #   The given block will be passed each discovered SQL Injection
      #   vulnerability.
      #
      # @yieldparam [Injection] sqli
      #   A discovered SQL Injection vulnerability.
      #
      # @return [Enumerator]
      #   If no block is given, an enumerator object will be returned.
      #
      # @since 0.3.0
      #
      def Injection.scan(url,options={})
        return enum_for(:scan,url,options) unless block_given?

        url = URI(url.to_s) unless url.kind_of?(URI)

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
            inj = Injection.new(url,param,options.merge(test))

            if inj.vulnerable?(options)
              yield inj
              break
            end
          end
        end
      end

      #
      # Creates a new Code::SQL::Injection object using the given _options_
      # and _block_. The given _options_ will be merged with the injections
      # sql_options, to create a tailored Code::SQL::Injection object.
      #
      def sql(options={},&block)
        Code::SQL::Injection.new(@sql_options.merge(options),&block)
      end

      def inject(options={},&block)
        injection = (options[:sql] || sql(options,&block))

        injection_url = URI(@url.to_s)
        injection_url.query_params[@param.to_s] = injection

        request_method = (options[:method] || @http_method)
        options = options.merge(:url => injection_url)

        if request_method == :post
          return http_post_body(options)
        else
          return http_get_body(options)
        end
      end

      def inject_error(options={})
        inject({:sql => "'"}.merge(options))
      end

      def error(options={})
        inject_error(options).sql_error
      end

      def has_error?(options={})
        Error.has_message?(inject_error(options))
      end

      def vulnerable?(options={})
        body1 = inject(options) { no_rows }
        body2 = inject(options) { all_rows }

        if (body1.sql_error? || body2.sql_error?)
          return false
        end

        body1 = Nokogiri::HTML(body1)
        body2 = Nokogiri::HTML(body2)

        return body1.total_children < body2.total_children
      end

      def has_column?(column,options={})
        body1 = inject(options)
        body2 = inject(options.merge(:symbols => {:column => column})) do
          has_column?(column)
        end

        if (body1.sql_error? || body2.sql_error?)
          return false
        end

        body1 = Nokogiri::HTML(body1)
        body2 = Nokogiri::HTML(body2)

        return body1.total_children == body2.total_children
      end

      def has_table?(table,options={})
        body1 = inject(options)
        body2 = inject(options.merge(:symbols => {:table => table})) do
          has_table?(table)
        end

        if (body1.sql_error? || body2.sql_error?)
          return false
        end

        body1 = Nokogiri::HTML(body1)
        body2 = Nokogiri::HTML(body2)

        return body1.total_children == body2.total_children
      end

      def uses_column?(column,options={})
        body1 = inject(options)
        body2 = inject(options.merge(:symbols => {:column => column})) do
          uses_column?(table)
        end

        if (body1.sql_error? || body2.sql_error?)
          return false
        end

        body1 = Nokogiri::HTML(body1)
        body2 = Nokogiri::HTML(body2)

        return body1.total_children == body2.total_children
      end

      def uses_table?(table,options={})
        body1 = inject(options)
        body2 = inject(options.merge(:symbols => {:table => table})) do
          uses_table?(table)
        end

        if (body1.sql_error? || body2.sql_error?)
          return false
        end

        body1 = Nokogiri::HTML(body1)
        body2 = Nokogiri::HTML(body2)

        return body1.total_children == body2.total_children
      end

      def to_s
        @url.to_s
      end

    end
  end
end
