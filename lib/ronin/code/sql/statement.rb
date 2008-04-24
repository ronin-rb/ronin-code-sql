#
#--
# Ronin SQL - A Ronin library providing support for SQL related security
# tasks.
#
# Copyright (c) 2007-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/code/sql/expr'
require 'ronin/code/sql/field'
require 'ronin/code/sql/binary_expr'
require 'ronin/code/sql/unary_expr'
require 'ronin/code/sql/like_expr'
require 'ronin/code/sql/in'
require 'ronin/extensions/meta'

module Ronin
  module Code
    module SQL
      class Statement < Expr

        def initialize(style,&block)
          super(style)

          instance_eval(&block) if block
        end

        protected

        def self.option(name,value=nil)
          class_eval %{
            def #{name}(&block)
              instance_variable_set("@#{name}",true)

              instance_eval(&block) if block
              return self
            end
          }

          class_def("#{name}?") do
            if value
              keyword(value.to_s) if instance_variable_get("@#{name}")
            else
              instance_variable_get("@#{name}")
            end
          end
        end

        def self.option_list(name,values=[])
          values.each do |opt|
            class_eval %{
              def #{opt}_#{name}(&block)
                instance_variable_set("@#{name}",'#{opt.to_s.upcase}')

                instance_eval(&block) if block
                return self
              end
            }
          end

          class_def("#{name}?") do
            opt = instance_variable_get("@#{name}")

            return keyword(opt) if opt
            return nil
          end
        end

        def all
          field_cache[:'*']
        end

        def id
          field_cache[:id]
        end

        def method_missing(sym,*args,&block)
          if @style.dialect.expresses?(sym)
            return @style.dialect.express(sym,*args,&block)
          end

          # return a field
          return field_cache[sym] if args.empty?

          return super(sym,*args,&block)
        end

        private

        def field_cache
          @field_cache ||= Hash.new { |hash,key| hash[key] = Field.new(@style,key) }
        end

      end
    end
  end
end
