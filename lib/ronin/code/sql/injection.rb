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

        # Comment-Obfustication
        attr_accessor :comment_evasion

        # Swapcase-Obfusciation
        attr_accessor :case_evasion

        # Injected expression
        attr_reader :expression

        # Value to use within the escape String
        attr_accessor :escape_value

        # Token to use in the escape String
        attr_accessor :escape_token

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

          case options[:escape]
          when :string
            @escape_token = "'"
          when :parenthesis
            @escape_token = ')'
          when :statement
            @escape_token = ';'
          else
            @escape_value = options[:escape]
          end

          super(options) {}

          instance_eval(&block) if block
        end

        def inject(&block)
          @expression = InjectedStatement.new(@dialect,&block)
          return self
        end

        def escape(value=1,&block)
          @escape_value = value
          return inject(&block)
        end

        def escape_string(value='',&block)
          escape(value,&block)
        end

        def escape_parenthesis(value='',&block)
          escape(nil,&block)
        end

        def escape_statement(&block)
          escape(nil,&block)
        end

        def sql(&block)
          @dialect.instance_eval(&block) if block
        end

        def compile
          injection = super.rstrip

          if (@escape_token && injection[-1..-1] == @escape_token)
            return injection.chop
          else
            return [injection, '--'].join(space_token)
          end
        end

        alias to_s compile

        protected

        def space_token
          if @comment_evasion
            return '/**/'
          else
            return super
          end
        end

        def format_token(token)
          token = super(token)

          if @case_evasion
            token = token.random_case
          end

          return token
        end

        def each_string(&block)
          if (@escape_value || @escape_token)
            block.call("#{@escape_value}#{@escape_token}")
          end

          return super(&block)
        end

        def each_token(&block)
          if @expression
            @expression.emit.each(&block)

            block.call(Token.separator)
          end

          return super(&block)
        end

      end
    end
  end
end
