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
require 'ronin/sessions/http'

module Ronin
  module SQL
    class Injection

      include Sessions::HTTP

      # The URL to inject upon
      attr_reader :url

      # The URL query param to inject into
      attr_reader :param

      attr_reader :sql

      def initialize(url,param,options={})
        @url = url
        @param = param
        @sql = {}

        @sql.merge!(options[:sql]) if options[:sql]

        super(options)
      end

      def inject(options={},&block)
        url = URI(@url.to_s)
        url.query_param[@param] = Code.sql_injection(@sql.merge(options),&block)

        return http_get_body(options.merge(:url => url))
      end

      def vulnerable?(options={})
        no_rows = inject(options) { no_rows }
        all_rows = inject(options) { all_rows }

        if (SQL.has_error?(no_rows) || SQL.has_error?(all_rows))
          return false
        end

        no_rows = Hpricot(no_rows)
        all_rows = Hpricot(all_rows)

        return no_rows < all_rows
      end

      def to_s
        @url.to_s
      end

    end
  end
end
