# frozen_string_literal: true
#
# ronin-code-sql - A Ruby DSL for crafting SQL Injections.
#
# Copyright (c) 2007-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/code/sql/literals'
require 'ronin/code/sql/fields'
require 'ronin/code/sql/functions'
require 'ronin/code/sql/statement'
require 'ronin/code/sql/statements'
require 'ronin/code/sql/emittable'

module Ronin
  module Code
    module SQL
      #
      # Represents a SQL Clause.
      #
      # @api semipublic
      #
      class Clause < Struct.new(:keyword,:argument)

        include Literals
        include Fields
        include Functions
        include Statements
        include Emittable

        #
        # Initializes the SQL clause.
        #
        # @param [Symbol] keyword
        #   The name of the clause.
        #
        # @param [Object] argument
        #   Additional argument for the clause.
        #
        # @yield [(clause)]
        #   If a block is given, the return value will be used as the argument.
        #
        # @yieldparam [Clause] clause
        #   If the block accepts an argument, it will be passed the new clause.
        #   Otherwise the block will be evaluated within the clause.
        #
        def initialize(keyword,argument=nil,&block)
          super(keyword,argument)

          if block
            self.argument = case block.arity
                            when 0 then instance_eval(&block)
                            else        block.call(self)
                            end
          end
        end

      end
    end
  end
end
