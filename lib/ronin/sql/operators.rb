#
# Ronin SQL - A Ruby DSL for crafting SQL Injections.
#
# Copyright (c) 2007-2013 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin SQL.
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

module Ronin
  module SQL
    #
    # Methods for creating SQL expressions.
    #
    # @see http://sqlite.org/lang_expr.html
    #
    module Operators
      #
      # Multiplication.
      #
      # @return [BinaryExpr]
      #   The new binary expression.
      #
      def *(other)
        BinaryExpr.new(self,:*,other)
      end

      #
      # Division.
      #
      # @return [BinaryExpr]
      #   The new binary expression.
      #
      def /(other)
        BinaryExpr.new(self,:/,other)
      end

      #
      # Modulus.
      #
      # @return [BinaryExpr]
      #   The new binary expression.
      #
      def %(other)
        BinaryExpr.new(self,:%,other)
      end

      #
      # Addition.
      #
      # @return [BinaryExpr]
      #   The new binary expression.
      #
      def +(other)
        BinaryExpr.new(self,:+,other)
      end

      #
      # Subtraction.
      #
      # @return [BinaryExpr]
      #   The new binary expression.
      #
      def -(other)
        BinaryExpr.new(self,:-,other)
      end

      #
      # Bit-wise left shift.
      #
      # @return [BinaryExpr]
      #   The new binary expression.
      #
      def <<(other)
        BinaryExpr.new(self,:<<,other)
      end

      #
      # Bit-wise right shift.
      #
      # @return [BinaryExpr]
      #   The new binary expression.
      #
      def >>(other)
        BinaryExpr.new(self,:>>,other)
      end

      #
      # Bit-wise `AND`.
      #
      # @return [BinaryExpr]
      #   The new binary expression.
      #
      def &(other)
        BinaryExpr.new(self,:&,other)
      end

      #
      # Bit-wise `OR`.
      #
      # @return [BinaryExpr]
      #   The new binary expression.
      #
      def |(other)
        BinaryExpr.new(self,:|,other)
      end

      #
      # Less than.
      #
      # @return [BinaryExpr]
      #   The new binary expression.
      #
      def <(other)
        BinaryExpr.new(self,:<,other)
      end

      #
      # Less than or equal to.
      #
      # @return [BinaryExpr]
      #   The new binary expression.
      #
      def <=(other)
        BinaryExpr.new(self,:<=,other)
      end

      #
      # Greater than.
      #
      # @return [BinaryExpr]
      #   The new binary expression.
      #
      def >(other)
        BinaryExpr.new(self,:>,other)
      end

      #
      # Greater than or equal to.
      #
      # @return [BinaryExpr]
      #   The new binary expression.
      #
      def >=(other)
        BinaryExpr.new(self,:>=,other)
      end

      #
      # Equal to.
      #
      # @return [BinaryExpr]
      #   The new binary expression.
      #
      def ==(other)
        BinaryExpr.new(self,:"=",other)
      end

      #
      # Not equal to.
      #
      # @return [BinaryExpr]
      #   The new binary expression.
      #
      def !=(other)
        BinaryExpr.new(self,:!=,other)
      end

      #
      # Alias.
      #
      # @return [BinaryExpr]
      #   The new binary expression.
      #
      def as(name)
        BinaryExpr.new(self,:AS,name)
      end

      #
      # `IS` comparison.
      #
      # @return [BinaryExpr]
      #   The new binary expression.
      #
      def is(other)
        BinaryExpr.new(self,:IS,other)
      end

      #
      # `IS NOT` comparison.
      #
      # @return [BinaryExpr]
      #   The new binary expression.
      #
      def is_not(other)
        BinaryExpr.new(self,:"IS NOT",other)
      end

      #
      # `LIKE` comparison.
      #
      # @return [BinaryExpr]
      #   The new binary expression.
      #
      def like(other)
        BinaryExpr.new(self,:LIKE,other)
      end

      #
      # `GLOB` comparison.
      #
      # @return [BinaryExpr]
      #   The new binary expression.
      #
      def glob(other)
        BinaryExpr.new(self,:GLOB,other)
      end

      #
      # `MATCH` comparison.
      #
      # @return [BinaryExpr]
      #   The new binary expression.
      #
      def match(other)
        BinaryExpr.new(self,:MATCH,other)
      end

      #
      # `REGEXP` comparison.
      #
      # @return [BinaryExpr]
      #   The new binary expression.
      #
      def regexp(other)
        BinaryExpr.new(self,:REGEXP,other)
      end

      #
      # `REGEXP` comparison.
      #
      # @return [BinaryExpr]
      #   The new binary expression.
      #
      def in(other)
        BinaryExpr.new(self,:IN,other)
      end

      #
      # Unary minus.
      #
      # @return [UnaryExpr]
      #   The new binary expression.
      #
      def -@
        UnaryExpr.new(:-,self)
      end

      #
      # Unary plus.
      #
      # @return [UnaryExpr]
      #   The new binary expression.
      #
      def +@
        UnaryExpr.new(:+,self)
      end

      #
      # Bit-wise negate.
      #
      # @return [UnaryExpr]
      #   The new binary expression.
      #
      def ~
        UnaryExpr.new(:~,self)
      end

      #
      # Logical negate.
      #
      # @return [UnaryExpr]
      #   The new binary expression.
      #
      def !
        UnaryExpr.new(:!,self)
      end

      #
      # Logical `NOT`.
      #
      # @return [UnaryExpr]
      #   The new binary expression.
      #
      def not
        UnaryExpr.new(:NOT,self)
      end

      #
      # `AND`.
      #
      # @return [BinaryExpr]
      #   The new binary expression.
      #
      def and(other)
        BinaryExpr.new(self,:AND,other)
      end

      #
      # `OR`.
      #
      # @return [BinaryExpr]
      #   The new binary expression.
      #
      def or(other)
        BinaryExpr.new(self,:OR,other)
      end
    end
  end
end
