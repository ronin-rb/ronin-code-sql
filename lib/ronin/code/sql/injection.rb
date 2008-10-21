#
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
#

require 'ronin/code/sql/program'
require 'ronin/code/sql/injected_statement'
require 'ronin/formatting/text'

module Ronin
  module Code
    module SQL
      class Injection < Program

        # Comment-Obfusticate all keywords
        attr_accessor :comment_evasion

        # Swapcase-Obfusciate all keywords
        attr_accessor :case_evasion

        def initialize(options={},&block)
          if options.has_key?(:comment_evasion)
            @comment_evasion = options[:comment_evasion]
          else
            @comment_evasion = false
          end

          if options.has_key?(:case_evasion)
            @case_evasion = options[:case_evasion]
          else
            @case_evasion = false
          end

          @escape_value = nil
          @escape_token = nil
          @expression = nil

          super(options,&block)
        end

        def escape_with(value=1,&block)
          @escape_value = value

          block.call if block
          return self
        end

        def escape_string(value='',&block)
          @escape_token = "'"

          return escape_with(value,&block)
        end

        def escape_parenthesis(value='',&block)
          @escape_token = ')'

          return escape_with(nil,&block)
        end

        def escape_statement(&block)
          @escape_token = ';'

          return escape_with(nil,&block)
        end

        def inject(&block)
          @expression = InjectedStatement.new(self,&block)
        end

        def compile
          injection = ''

          if (@escape_value || @escape_token)
            injection << @escape_value if @escape_value
            injection << @escape_token if @escape_token

            injection << space_token
          end
          
          injection << super.rstrip

          if (@escape_token && injection[-1..-1] == @escape_token)
            return injection.chop!
          else
            return [injection, '--'].join(space_token)
          end
        end

        protected

        def space_token
          if @comment_evasion
            return '/**/'
          else
            return super
          end
        end

        def format_keyword(keyword)
          if @case_evasion
            return super(keyword).random_case
          else
            return super(keyword)
          end
        end

        def each_token(&block)
          if @escape_value
            block.call(@escape_value)
          end

          if @escape_token
            block.call(@escape_token)
          end

          if @expression
            formatted_tokens(@expression.emit,&block)
          end

          return super(&block)
        end

      end
    end
  end
end
