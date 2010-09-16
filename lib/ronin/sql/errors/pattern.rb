#
# Ronin SQL - A Ronin library providing support for SQL related security
# tasks.
#
# Copyright (c) 2007-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/sql/errors/message'

module Ronin
  module SQL
    module Errors
      class Pattern

        # Name of the pattern
        attr_reader :name

        # Name of the SQL dialect
        attr_accessor :dialect

        # Patterns to use for matching SQL errors
        attr_reader :patterns

        #
        # Creates a new Pattern object with the specified _name_. If a
        # _block_ is given, it will be passed the newly created Pattern
        # object.
        #
        def initialize(name,&block)
          @dialect = :common
          @name = name.to_sym
          @patterns = []

          block.call(self) if block
        end

        #
        # Add the specified _pattern_ to be used to recognize SQL error
        # messages.
        #
        def recognize(pattern)
          @patterns << pattern
          return self
        end

        #
        # Returns the first match between the error pattern and the
        # specified _data_. If no matches were found `nil` will be
        # returned.
        #
        def match(data)
          data = data.to_s

          @patterns.each do |pattern|
            match = data.match(pattern)

            return Message.new(@name,@dialect,match[0]) if match
          end

          return nil
        end

        #
        # Returns the match index within the specified _data_ where a SQL
        # error Pattern occurs. If no SQL error Pattern can be found within
        # _data_, `nil` will be returned.
        #
        def =~(data)
          data = data.to_s

          @patterns.each do |pattern|
            if (index = (pattern =~ data))
              return index
            end
          end

          return nil
        end

        #
        # Returns the name of the error pattern.
        #
        def to_s
          @name.to_s
        end

      end
    end
  end
end
