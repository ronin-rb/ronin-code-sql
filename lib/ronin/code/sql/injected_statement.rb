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

require 'ronin/code/sql/statement'

module Ronin
  module Code
    module SQL
      class InjectedStatement < Statement

        def initialize(dialect,&block)
          @expressions = []

          super(dialect,&block)
        end

        def inject_and(expr)
          @expressions += [Keyword.new('AND'), expr]
          return self
        end

        def inject_or(expr)
          @expressions += [Keyword.new('OR'), expr]
          return self
        end

        def all_rows(value=1)
          inject_or(BinaryExpr.new('=',value,value))
        end

        def exact_rows(value=1)
          inject_and(BinaryExpr.new('=',value,value))
        end

        def has_field?(name)
          inject_or(field(name).is_not?(null))
        end

        def has_table?(table)
          inject_and(select_from(table,:fields => count(all), :from => table) == 1)
        end

        def uses_table?(table)
          inject_or(table.is_not?(null))
        end

        def emit
          emit_values(@expressions) + super
        end

        protected

        def clause(name,*arguments)
          dialect.caluse(name,*arguments)
        end

        def method_missing(name,*arguments,&block)
          if (dialect.has_clause?(name) && block.nil?)
            return caluse(name,*arguments)
          end

          return super(name,*arguments,&block)
        end

      end
    end
  end
end
