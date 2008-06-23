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

        # The style to use
        attr_reader :style

        def initialize(style)
          @style = style
        end

        def Dialect.dialects
          @@dialects ||= {}
        end

        def Dialect.has_dialect?(name)
          Dialect.dialects.has_key?(name.to_sym)
        end

        def Dialect.get_dialect(name)
          name = name.to_sym

          unless Dialect.has_dialect?(name)
            raise(UnknownDialect,"unknown dialect #{name.dump}",caller)
          end

          return Dialect.dialects[name]
        end

        def expresses?(name)
          public_methods.include?(name.to_s)
        end

        def express(name,*args,&block)
          unless expresses?(name)
            raise(NameError,"undefined method '#{name}' for #{self}",caller)
          end

          return send(name,*args,&block)
        end

        def field(name)
          field_cache[name.to_sym]
        end

        protected

        def self.dialect(name)
          name = name.to_sym

          class_def(:name) { name }

          Dialect.dialects[name] = self
          return self
        end

        def self.keyword(name,value=name.to_s.upcase)
          name = name.to_s.downcase

          class_def("keyword_#{name}") { keyword(value) }
          return self
        end

        def self.primitives(*names)
          names.each do |name|
            name = name.to_s.downcase

            class_def(name) { keyword(name) }
          end

          return self
        end

        def self.data_type(name,options={})
          name = name.to_s.downcase
          type_name = name.upcase.to_sym

          if options[:length]==true
            class_def(name) do |length|
              if length
                "#{type_name}(#{length})"
              else
                type_name
              end
            end
          else
            class_def(name) { type_name }
          end

          return self
        end

        def self.function(*names)
          names.each do |name|
            class_def(name) do |field|
              Function.new(@style,name,field)
            end
          end

          return self
        end

        def self.aggregators(*names)
          function(*names)
        end

        def self.command(name,base)
          class_eval %{
            def #{name}(*args,&block)
              #{base}.new(@style,*args,&block)
            end
          }

          return self
        end

        def keyword(value)
          keyword_cache[value.to_sym]
        end

        private

        def keyword_cache
          @keyword_cache ||= Hash.new { |hash,key| hash[key] = Keyword.new(@style,key) }
        end

        def field_cache
          @field_cache ||= Hash.new { |hash,key| hash[key] = Field.new(@style,key) }
        end

      end
    end
  end
end
