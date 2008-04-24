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

require 'ronin/code/sql/statement'
require 'ronin/code/sql/injection_style'

module Ronin
  module Code
    module SQL
      class InjectionBuilder < Statement

        def initialize(style,&block)
          @escape = nil
          @escape_data = nil
          @expressions = []
          @program = nil

          super(style,&block)
        end

        def escape(var=1,&block)
          @escape = nil
          @escape_data = var

          block.call if block
          return self
        end

        def inject(*expr)
          @expressions += expr
          return self
        end

        def inject_and(expr)
          inject(keyword_and, expr)
        end

        def inject_or(expr)
          inject(keyword_or, expr)
        end

        def inject_sql(options={},&block)
          @program = Program.new(@style,options,&block)
        end

        def all_rows(var=1)
          inject_or(BinaryExpr.new(@style,'=',var,var))
        end

        def exact_rows(var=1)
          inject_and(BinaryExpr.new(@style,'=',var,var))
        end

        def has_table?(table)
          inject_or(select_from(table,:fields => count(all), :from => table)==1)
        end

        def has_field?(field)
          inject_or(field.is_not?(null))
        end

        def uses_table?(table)
          inject_or(table.is_not?(null))
        end

        def compile
          injection_expr = lambda {
            compile_expr("#{@escape_data}#{@escape}",*(@expressions))
          }

          append_comment = lambda { |str|
            compile_expr(str,'--')
          }

          if @program
            return compile_statements(injection_expr.call,append_comment.call(@program))
          else
            injection = injection_expr.call

            if (@escape && injection =~ /#{@escape}\s*$/)
              return injection.rstrip.chop
            else
              return append_comment.call(injection)
            end
          end
        end

        protected

        keyword :or
        keyword :and

        def self.escape(name,char)
          name = name.to_s.downcase.to_sym
          char = char.to_s

          class_eval %{
            def escape_#{name}(var=nil,&block)
              @escape = #{char.dump}
              @escape_data = var

              block.call if block
              return self
            end
          }

          return self
        end

        escape :string, "'"
        escape :parenthesis, ')'
        escape :statement, ';'

      end
    end
  end
end
