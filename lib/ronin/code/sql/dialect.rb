#
#--
# Ronin SQL - A Ronin library providing support for SQL related security
# tasks.
#
# Copyright (c) 2007 Hal Brodigan (postmodern at users.sourceforge.net)
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

require 'ronin/code/sql/exceptions/unknown_dialect'
require 'ronin/code/sql/function'
require 'ronin/extensions/meta'

module Ronin
  module Code
    module SQL
      class Dialect

        #
        # Creates a new Dialect object connected to the specified
        # _program_.
        #
        def initialize(program,name)
          @program = program
          @name = name
        end

        #
        # Returns the Hash of defined SQL dialects.
        #
        def Dialect.dialects
          @@dialects ||= {}
        end

        #
        # Returns +true+ if there is a SQL Dialect defined with the
        # specified _name_, returns +false+ otherwise.
        #
        def Dialect.has_dialect?(name)
          Dialect.dialects.has_key?(name.to_sym)
        end

        #
        # Returns the SQL Dialect defined with the specified _name_. If no
        # such SQL Dialect exists, an UnknownDialect exception will be
        # raised.
        #
        def Dialect.get(name)
          name = name.to_sym

          unless Dialect.has_dialect?(name)
            raise(UnknownDialect,"unknown dialect #{name}",caller)
          end

          return Dialect.dialects[name]
        end

        protected

        #
        # Defines a SQL Dialect with the specified _name_.
        #
        def self.dialect(name)
          Dialect.dialects[name.to_sym] = self
          return self
        end

        #
        # Defines various SQL primitives with the specified _names_.
        #
        def self.primitives(*names)
          names.each do |name|
            name = name.to_s.downcase

            class_def(name) { Keyword.new(name) }
          end

          return self
        end

        #
        # Defines a SQL data-type with the specified _name_ and given
        # _options_.
        #
        def self.data_type(name,options={})
          name = name.to_s.downcase
          type_name = name.upcase
          supports_length = options[:length]

          class_def(name) do |length|
            if (supports_length && length)
              Keyword.new("#{type_name}(#{length})")
            else
              Keyword.new(type_name)
            end
          end

          return self
        end

        #
        # Defines various SQL function with the specified _names_.
        #
        def self.functions(*names)
          names.each do |name|
            class_def(name) do |*fields|
              Function.new(@program,name,*fields)
            end
          end

          return self
        end

        #
        # Defines various SQL aggregate functions with the specified
        # _names_.
        #
        def self.aggregators(*names)
          names.each do |name|
            class_def(name) do |field|
              Function.new(@program,name,field)
            end
          end

          return self
        end

        #
        # Defines an SQL statement with the specified _name_ and _base_
        # class.
        #
        def self.statement(name,base)
          class_eval %{
            def #{name}(*arguments,&block)
              #{base}.new(@program,*arguments,&block)
            end
          }

          return self
        end

      end
    end
  end
end
