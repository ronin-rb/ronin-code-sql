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

require 'ronin/code/sql/emittable'
require 'ronin/extensions/meta'

module Ronin
  module Code
    module SQL
      class Expr

        include Emittable

        def in?(*range)
          In.new(self,*range)
        end

        def ===(*range)
          in?(*range)
        end

        def not_in?(*range)
          in?(*range).not!
        end

        protected

        def self.binary_op(op,*names)
          names.each do |name|
            class_def(name) do |expr|
              BinaryExpr.new(op,self,expr)
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
              Like.new(op,self,expr,escape)
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
              UnaryExpr.new(op,self)
            end
          end

          return self
        end

        unary_op 'NOT', :not!
        unary_op 'EXISTS', :exists?

      end
    end
  end
end
