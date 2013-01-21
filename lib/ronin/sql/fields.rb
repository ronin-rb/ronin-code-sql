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

require 'ronin/sql/field'

module Ronin
  module SQL
    #
    # Allows creating {Field Fields} via {#method_missing}.
    #
    module Fields
      #
      # @return [true]
      #
      def respond_to_missing?(name)
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
