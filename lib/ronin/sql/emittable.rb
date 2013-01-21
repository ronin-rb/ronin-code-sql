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

require 'ronin/sql/emitter'

module Ronin
  module SQL
    #
    # Allows an object to be converted to raw SQL.
    #
    module Emittable
      #
      # Creates a new emitter.
      #
      # @param [Hash] options
      #   Additional options for {Emitter#initialize}.
      #   
      def emitter(options={})
        Emitter.new(options)
      end

      #
      # The default `to_sql` method.
      #
      # @param [Hash] options
      #   Additional options for {#emitter}.
      #
      # @option options [:lower, :upper, :random, nil] :case
      #   Case for keywords.
      #
      # @option options [String] :space (' ')
      #   String to use for white-space.
      #
      # @option options [:single, :double] :quote (:single)
      #   Type of quotes to use for Strings.
      #
      # @return [String]
      #   The raw SQL.
      #
      # @raise [ArgumentError]
      #   Could not emit an unknown SQL object.
      #
      def to_sql(options={})
        emitter(options).emit(self)
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
