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

require 'ronin/code/sql/emitter'

module Ronin
  module Code
    module SQL
      #
      # Allows an object to be converted to raw SQL.
      #
      # @api public
      #
      module Emittable
        #
        # Creates a new emitter.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {Emitter#initialize}.
        #
        # @api private
        #   
        def emitter(**kwargs)
          Emitter.new(**kwargs)
        end

        #
        # The default `to_sql` method.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {Emitter#initialize}.
        #
        # @option kwargs [:lower, :upper, :random, nil] :case
        #   Case for keywords.
        #
        # @option kwargs [String] :space (' ')
        #   String to use for white-space.
        #
        # @option kwargs [:single, :double] :quotes (:single)
        #   Type of quotes to use for Strings.
        #
        # @return [String]
        #   The raw SQL.
        #
        # @raise [ArgumentError]
        #   Could not emit an unknown SQL object.
        #
        def to_sql(**kwargs)
          emitter(**kwargs).emit(self)
        end

        #
        # @see #to_sql
        #
        def to_s
          to_sql
        end

        #
        # Inspects the object.
        #
        # @return [String]
        #   The inspected object.
        #
        def inspect
          "#<#{self.class}: #{to_sql}>"
        end
      end
    end
  end
end
