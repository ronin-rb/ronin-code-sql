#
# Ronin SQL - A Ruby DSL for crafting SQL Injections.
#
# Copyright (c) 2007-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
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
    module Emittable
      #
      # Emits SQL.
      #
      # @param [Hash] options
      #   Additional options for {Emitter}.
      #
      # @raise [NotImplementedError]
      #   This method must be implemented.
      #
      def to_sql(options={})
        raise(NotImplementedError,"#{self.class}#to_sql is not implemented")
      end

      #
      # @see #to_sql
      #
      def to_s
        to_sql
      end

      #
      # @see #to_sql
      #
      def to_str
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
