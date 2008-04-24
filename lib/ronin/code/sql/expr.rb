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

require 'ronin/code/sql/keyword'
require 'ronin/extensions/meta'

module Ronin
  module Code
    module SQL
      class Expr

        # The style to use
        attr_reader :style

        def initialize(style)
          @style = style
        end

        def in?(*range)
          In.new(@style,self,*range)
        end

        def ===(*range)
          in?(*range)
        end

        def not_in?(*range)
          in?(*range).not!
        end

        def compile
          # place holder
        end

        def to_s
          compile
        end

        protected

        def keyword(value)
          keyword_cache[value.to_sym]
        end

        def keywords(*values)
          values.map { |value| keyword(value) }
        end

        def self.keyword(name,value=name.to_s.upcase)
          name = name.to_s.downcase

          class_def("keyword_#{name}") do
            keyword(value)
          end

          return self
        end

        def self.binary_op(op,*names)
          names.each do |name|
            class_def(name) do |expr|
              BinaryExpr.new(@style,op,self,expr)
            end
          end

          return self
        end

        binary_op '=', '==', :equals?
        binary_op '!=', :not_equals?
        binary_op '<>', '<=>', :different?
        binary_op '>', '>', :greater?
        binary_op '>=', '>=', :greater_equal?
        binary_op '<', '<', :less?
        binary_op '<=', '<=', :less_equal?
        binary_op 'IS', :is?
        binary_op 'IS NOT', :is_not?
        binary_op 'AS', :as
        binary_op 'CAST', :cast
        binary_op 'OR', :or
        binary_op 'XOR', :xor
        binary_op 'AND', :and

        def self.like_op(op,*names)
          names.each do |name|
            class_def(name) do |expr,escape|
              LikeExpr.new(@style,op,self,expr,escape)
            end
          end

          return self
        end

        like_op 'LIKE', :like
        like_op 'GLOB', :glob
        like_op 'REGEXP', :regexp
        like_op 'MATCH', :match

        def self.unary_op(op,*names)
          names.each do |name|
            class_def(name) do
              UnaryExpr.new(@style,op,self)
            end
          end

          return self
        end

        unary_op 'NOT', :not!
        unary_op 'EXISTS', :exists?

        def compile_space
          @style.compile_space
        end

        def preappend_space(str)
          @style.preappend_space(str)
        end

        def append_space(str)
          @style.append_space(str)
        end

        def space(*str)
          @style.space(*str)
        end

        def compile_newline
          @style.compile_newline
        end

        def quote_string(data)
          @style.quote_string(data)
        end

        def compile_keyword(name)
          @style.compile_keyword(name)
        end

        def compile_list(*expr)
          @style.compile_list(*expr)
        end

        def compile_datalist(*expr)
          @style.compile_list(*expr)
        end

        def compile_row(*expr)
          @style.compile_row(*expr)
        end

        def compile_data(data)
          @style.compile_data(data)
        end

        def compile_expr(*expr)
          @style.compile_expr(*expr)
        end

        def compile_statements(*statements)
          @style.compile_statements(*statements)
        end

        private

        def keyword_cache
          @keyword_cache ||= Hash.new { |hash,key| hash[key] = Keyword.new(@style,key) }
        end

      end
    end
  end
end
