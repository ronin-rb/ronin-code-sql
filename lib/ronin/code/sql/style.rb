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

require 'ronin/code/sql/dialect'
require 'ronin/code/sql/common_dialect'

module Ronin
  module Code
    module SQL
      class Style

        # The dialect of SQL
        attr_reader :dialect

        # Use single-line or multi-line style
        attr_accessor :multiline

        # Use lowercase style
        attr_accessor :lowercase

        # Compile with less parenthesis
        attr_accessor :less_parenthesis

        # Space string
        attr_accessor :space

        # New-line string
        attr_accessor :newline

        def initialize(options={})
          @dialect = Dialect.get_dialect(options[:dialect] || :common).new(self)

          if options[:multiline].nil?
            @multiline = true
          else
            @multiline = options[:multiline]
          end

          if options[:lowercase].nil?
            @lowercase = false
          else
            @lowercase = options[:lowercase]
          end

          if options[:less_parenthesis].nil?
            @less_parenthesis = false
          else
            @less_parenthesis = options[:less_parenthesis]
          end

          @space = (options[:space] || ' ')
          @newline = (options[:newline] || "\n")
        end

        def compile_space
          if @space.kind_of?(Array)
            return @space[rand(@space.length)].to_s
          else
            return @space.to_s
          end
        end

        def preappend_space(str)
          compile_space + str.to_s
        end

        def append_space(str)
          str.to_s + compile_space
        end

        def compile_newline
          return compile_space unless @multiline

          if @newline.kind_of?(Array)
            return @newline[@newline.length * rand].to_s
          else
            return @newline.to_s
          end
        end

        def quote_string(data)
         "'" + data.to_s.sub("'","''") + "'"
        end

        def compile_keyword(name)
          name = name.to_s

          if @lowercase
            return name.downcase
          else
            return name.upcase
          end
        end

        def compile_list(*exprs)
          exprs = exprs.flatten

          unless @less_parenthesis
            return exprs.compact.join(append_space(','))
          else
            return exprs.compact.join(',')
          end
        end

        def compile_datalist(*exprs)
          compile_row( exprs.flatten.map { |expr| compile_data(value) } )
        end

        def compile_row(*exprs)
          exprs = exprs.flatten

          unless exprs.length==1
            unless @less_parenthesis
              return "(#{compile_list(exprs)})"
            else
              return compile_list(exprs)
            end
          else
            return exprs[0].to_s
          end
        end

        def compile_data(data)
          if data.kind_of?(Array)
            return compile_datalist(data)
          elsif data.kind_of?(String)
            return quote_string(data)
          else
            return data.to_s
          end
        end

        def compile_expr(*expr)
          expr.compact.join(compile_space).strip
        end

        def compile_statements(statements,separator=compile_newline)
          if @multiline
            return statements.join(compile_newline)
          else
            return statements.join(append_space(';'))
          end
        end

      end
    end
  end
end
