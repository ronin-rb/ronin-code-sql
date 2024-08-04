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

require_relative 'literals'
require_relative 'clause'
require_relative 'clauses'
require_relative 'operators'
require_relative 'emittable'

module Ronin
  module Code
    module SQL
      #
      # Represents a SQL Statement.
      #
      # @api semipublic
      #
      class Statement

        include Literals
        include Operators
        include Clauses
        include Emittable

        # The statement name.
        #
        # @return [Symbol, Array<Symbol>]
        attr_reader :keyword

        # The statement's argument.
        #
        # @return [Object, nil]
        attr_reader :argument

        #
        # Initializes a new SQL statement.
        #
        # @param [Symbol, Array<Symbol>] keyword
        #   Name of the statement.
        #
        # @param [Object] argument
        #   Additional argument for the statement.
        #
        # @yield [(statement)]
        #   If a block is given, it will be called.
        #
        # @yieldparam [Statement] statement
        #   If the block accepts an argument, it will be passed the new statement.
        #   Otherwise the block will be evaluated within the statement.
        #
        def initialize(keyword,argument=nil,&block)
          @keyword  = keyword
          @argument = argument

          if block
            case block.arity
            when 0 then instance_eval(&block)
            else        block.call(self)
            end
          end
        end

      end
    end
  end
end
