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

require 'ronin/sql/errors/error'

module Ronin
  module SQL
    module Errors
      class Signature

        # Type of SQL server
        attr_accessor :software

        # Type of SQL server
        attr_accessor :vendor

        # Name of the SQL dialect
        attr_accessor :dialect

        # Patterns to use for matching SQL errors
        attr_reader :patterns

        #
        # Creates a new SQL Error Signature object.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [String] :server
        #   The name of the SQL Server that generates this type of error.
        #
        # @option options [String] :vendor
        #   The vendor of the SQL Server.
        #
        # @option options [Symbol] :dialect (:common)
        #   The dialect of SQL used by the SQL Server.
        #
        # @yield [sig]
        #   The given block will be passed the new SQL Error Signature.
        #
        # @yieldparam [Signature] sig
        #   The new SQL Error Signature object.
        #
        # @since 0.3.0
        #
        def initialize(options={})
          @software = options[:software]
          @vendor  = options[:vendor]
          @dialect = (options[:dialect] || :common)

          @patterns = []

          yield self if block_given?
        end

        #
        # Adds a new pattern to recognize SQL Errors.
        #
        # @param [Regexp] pattern
        #   The new recognizer pattern.
        #
        # @return [Signature]
        #   The SQL Error Signature.
        #
        # @since 0.3.0
        #
        def recognize(pattern)
          @patterns << pattern
          return self
        end

        #
        # Matches the data against the SQL Error Signature.
        #
        # @param [String] data
        #   The data to match.
        #
        # @return [Error, nil]
        #   The extracted SQL Error.
        #
        # @since 0.3.0
        #
        def match(data)
          data = data.to_s

          @patterns.each do |pattern|
            match = data.match(pattern)

            return Error.new(@software,@dialect,match[0]) if match
          end

          return nil
        end

        #
        # Finds the exact index the SQL Error Signature matches the data.
        #
        # @param [String] data
        #   The data to match.
        #
        # @return [Integer, nil]
        #   The index within the data that the SQL Error Signature matches.
        #
        # @since 0.3.0
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
        # The string representation of the SQL Error Signature.
        #
        # @return [String]
        #   The software name.
        #
        # @since 0.3.0
        #
        def to_s
          @software.to_s
        end

      end
    end
  end
end
