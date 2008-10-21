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

require 'ronin/code/sql/clause'

module Ronin
  module Code
    module SQL
      class JoinClause < Clause

        attr_accessor :table

        attr_accessor :natural

        attr_accessor :direction

        attr_accessor :side

        def initialize(program,table,options={})
          super(program)

          @table = table

          if options[:left]
            @direction = :left
          elsif options[:right]
            @direction = :right
          elsif options[:full]
            @direction = :full
          end

          if options[:inner]
            @direction = :inner
          elsif options[:outer]
            @direction = :outer
          elsif options[:cross]
            @direction = :cross
          end

          @natural = options[:natural]
        end

        def left
          @direction = :left
          return self
        end

        def right
          @direction = :right
          return self
        end

        def full
          @direction = :full
          return self
        end

        def inner
          @direction = :inner
          return self
        end

        def outer
          @direction = :outer
          return self
        end

        def cross
          @direction = :cross
          return self
        end

        def emit
          tokens = []

          tokens << Keyword.new('NATURAL') if @natural

          case @direction
          when :left, 'left'
            tokens << Keyword.new('LEFT')
          when :right, 'right'
            tokens << Keyword.new('RIGHT')
          when :full, 'full'
            tokens << Keyword.new('FULL')
          end

          case @side
          when :inner, 'inner'
            tokens << Keyword.new('INNER')
          when :outer, 'outer'
            tokens << Keyword.new('OUTER')
          when :cross, 'cross'
            tokens << Keyword.new('CROSS')
          end

          tokens << Keyword.new('JOIN')
          
          return tokens + emit_value(@table)
        end

      end
    end
  end
end
