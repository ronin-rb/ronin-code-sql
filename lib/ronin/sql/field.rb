#
# Ronin SQL - A Ruby DSL for crafting SQL Injections.
#
# Copyright (c) 2007-2021 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-sql.
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

require 'ronin/sql/operators'
require 'ronin/sql/emittable'

module Ronin
  module SQL
    #
    # Represents a SQL column, table or database name.
    #
    # @api semipublic
    #
    class Field < Struct.new(:name,:parent)

      include Operators
      include Emittable

      #
      # Initializes the new field.
      #
      # @param [String] name
      #   The name of the field.
      #
      # @param [Field] parent
      #   The parent of the field.
      #
      def initialize(name,parent=nil)
        super(name.to_s,parent)
      end

      #
      # Parses a field.
      #
      # @param [String] name
      #
      # @return [Field]
      #   The parsed field.
      #
      def self.parse(name)
        names = name.to_s.split('.',3)
        field = nil

        names.each { |name| field = new(name,field) }

        return field
      end

      alias to_str to_s

      protected

      #
      # Allows accessing columns from tables or tables from databases.
      #
      # @param [Symbol] name
      #   The sub-field name.
      #
      # @example
      #   db.users
      #
      # @example
      #   users.id
      #
      def method_missing(name,*arguments)
        unless arguments.empty?
          raise(ArgumentError,"canot access columns or tables with arguments")
        end

        if (self.parent.nil? || self.parent.parent.nil?)
          Field.new(name,self)
        else
          raise(NoMethodError,"cannot access coumns from other columns")
        end
      end

    end
  end
end
