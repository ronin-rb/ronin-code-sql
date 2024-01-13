# frozen_string_literal: true
#
# ronin-code-sql - A Ruby DSL for crafting SQL Injections.
#
# Copyright (c) 2007-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# ronin-code-sql is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-code-sql is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-code-sql.  If not, see <https://www.gnu.org/licenses/>.
#

module Ronin
  module Code
    module SQL
      #
      # Methods for creating SQL expressions.
      #
      # @api public
      #
      # @see http://sqlite.org/lang_expr.html
      #
      module Operators
        #
        # Multiplication.
        #
        # @param [Object] other
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
        # @param [Object] other
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
        # @param [Object] other
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
        # @param [Object] other
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
        # @param [Object] other
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
        # @param [Object] other
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
        # @param [Object] other
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
        # @param [Object] other
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
        # @param [Object] other
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
        # @param [Object] other
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
        # @param [Object] other
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
        # @param [Object] other
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
        # @param [Object] other
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
        # @param [Object] other
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
        # @param [Object] other
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
        # @param [Symbol] name
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
        # @param [Object] other
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
        # @param [Object] other
        #
        # @return [BinaryExpr]
        #   The new binary expression.
        #
        def is_not(other)
          BinaryExpr.new(self,[:IS, :NOT],other)
        end

        #
        # `LIKE` comparison.
        #
        # @param [Object] other
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
        # @param [Object] other
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
        # @param [Object] other
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
        # @param [Object] other
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
        # @param [Object] other
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
        # @param [Object] other
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
        # @param [Object] other
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
end
