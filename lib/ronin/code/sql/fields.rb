# frozen_string_literal: true
#
# ronin-code-sql - A Ruby DSL for crafting SQL Injections.
#
# Copyright (c) 2007-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/code/sql/field'

module Ronin
  module Code
    module SQL
      #
      # Allows creating {Field Fields} via {#method_missing}.
      #
      # @api public
      #
      module Fields
        #
        # Specifies that {#method_missing} will catch all missing methods.
        #
        # @param [Symbol] name
        #   The method name that is being checked.
        #
        # @param [Boolean] include_private
        #
        # @return [true]
        #
        def respond_to_missing?(name,include_private)
          true
        end

        #
        # @return [nil]
        #
        def to_ary
        end

        protected

        #
        # Allows specifying databases, tables or columns.
        #
        # @param [Symbol] name
        #   The field name to access.
        #
        # @param [Array] arguments
        #   Additional method arguments.
        #
        # @return [Field]
        #   The field object.
        #
        # @example
        #   db.users
        #
        # @example
        #   users.id
        #
        def method_missing(name,*arguments,&block)
          if (arguments.empty? && block.nil?)
            Field.new(name)
          else
            super
          end
        end
      end
    end
  end
end
