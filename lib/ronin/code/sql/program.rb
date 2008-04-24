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

require 'ronin/code/sql/style'
require 'ronin/code/sql/builder'

module Ronin
  module Code
    module SQL
      class Program

        def initialize(options={},&block)
          @builder = Builder.new(Style.new(options),&block)
        end

        def style
          @builder.style
        end

        def dialect
          @builder.style.dialect.name
        end

        def compile
          @builder.compile
        end

        def to_s
          compile
        end

        def self.compile(options={},&block)
          self.new(options,&block).compile
        end

        def url_encode
          compile.url_encode
        end

        def self.url_encode(*expr,&block)
          self.new(expr,&block).url_encode
        end

        def html_encode
          compile.html_encode
        end

        def self.html_(options={},&block)
          self.new(options,&block).html_encode
        end

        def base64_encode
          compile.base64_encode
        end

        def self.base64_encode(options={},&block)
          self.new(options,&block).base64_encode
        end

      end
    end
  end
end
