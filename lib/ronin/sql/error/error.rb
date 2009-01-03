#
#--
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
#++
#

require 'ronin/sql/error/pattern'

module Ronin
  module SQL
    module Error
      #
      # Returns all defined SQL Pattern objects.
      #
      def Error.patterns
        @@ronin_sql_error_patterns ||= {}
      end

      #
      # Defines a new SQL Pattern object with the given _options_.
      #
      def Error.pattern(name,&block)
        pattern = (Error.patterns[name] ||= Pattern.new(name))

        block.call(pattern) if block
        return pattern
      end

      #
      # Returns the SQL Pattern objects with the specified _names_.
      #
      def Error.patterns_for(*names)
        names.map { |name| Error.patterns[name] }.compact
      end

      #
      # Returns the SQL Pattern objects for the dialect with the
      # specified _name_.
      #
      def Error.patterns_for_dialect(name)
        Error.patterns.values.select do |pattern|
          pattern.dialect == name
        end
      end
    end
  end
end
