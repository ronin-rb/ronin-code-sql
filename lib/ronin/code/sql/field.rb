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

require 'ronin/code/sql/expr'
require 'ronin/code/sql/as'
require 'ronin/code/sql/between'
require 'ronin/code/sql/asc'
require 'ronin/code/sql/desc'

module Ronin
  module Code
    module SQL
      class Field < Expr

        def initialize(symbols,name,prefix=nil)
          @symbols = symbols
          @prefix = prefix
          @name = name
        end

        def field(name)
          sym = @symbols.symbol("#{path}.#{name}")
          sym.value ||= Field.new(@symbols,name,self)

          return sym
        end

        def all
          field('*')
        end

        alias * all

        def id
          field('id')
        end
        
        def as(name)
          As.new(self,name)
        end

        def between(start,stop)
          Between.new(self,start,stop)
        end

        def <=>(range)
          between(range.begin,range.end)
        end

        def asc
          Asc.new(self)
        end

        def desc
          Desc.new(self)
        end

        def emit
          [path.to_sym]
        end

        protected

        def path
          if @prefix
            return "#{@prefix}.#{@name}"
          else
            return "#{@name}"
          end
        end

        def method_missing(name,*arguments,&block)
          if (arguments.empty? && @prefix.nil? && block.nil?)
            return field(name)
          end

          raise(NoMethodError,sym.id2name)
        end

      end
    end
  end
end
