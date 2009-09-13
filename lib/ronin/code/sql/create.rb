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

require 'ronin/code/sql/statement'
require 'ronin/code/sql/fields_clause'

module Ronin
  module Code
    module SQL
      class Create < Statement

        clause :fields, FieldsClause

        def initialize(dialect,type,name=nil,options={},&block)
          @type = type
          @name = name
          @temp = (options[:temp] || options[:temporary])
          @if_not_exists = options[:if_not_exists]

          super(dialect,options,&block)
        end

        def temp!
          @temp = true
          return self
        end

        def temp?
          @temp == true
        end

        def if_not_exists!
          @if_not_exists = true
          return self
        end

        def if_not_exists?
          @if_not_exists == true
        end

        def emit
          tokens = emit_token('CREATE')
          tokens += emit_token('TEMP') if @temp

          tokens += emit_token(@type)

          tokens += emit_token('IF NOT EXISTS') if @if_not_exists
          tokens += emit_token(@name)

          return tokens + super
        end

      end
    end
  end
end
