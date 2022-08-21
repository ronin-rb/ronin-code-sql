#
# Ronin SQL - A Ruby DSL for crafting SQL Injections.
#
# Copyright (c) 2007-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-sql.
#
# ronin-sql is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-sql is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-sql.  If not, see <https://www.gnu.org/licenses/>.
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
      # @param [Array] arguments
      #   Additional mehtod arguments.
      #
      # @return [Field]
      #   The sub-field for the given name.
      #
      # @raise [ArgumentError]
      #   The method missing call was given additional arguments.
      #
      # @raise [NoMethodError]
      #   Cannot access a column from another column.
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
