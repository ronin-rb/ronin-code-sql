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

        # Data to escape a previous expression with
        attr_accessor :escape

        # Specifies whether or not to close an open string
        attr_accessor :close_string

        # Specifies whether or not to close an open parenthesis
        attr_accessor :close_parens

        # Specifies whether or not to end a previous statement
        attr_accessor :end_statement

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

          @escape = options[:escape]

          if options.has_key?(:close_string)
            @close_string = options[:close_string]
          else
            @close_string = false
          end

          if options.has_key?(:close_parens)
            @close_parens = options[:close_parens]
          else
            @close_parens = false
          end

          if options.has_key?(:end_statement)
            @end_statement = options[:end_statement]
          else
            @end_statement = false
          end

          super(options) do
            @expression = InjectedStatement.new(@dialect)
          end

          instance_eval(&block) if block
        end

        #
        # Returns the expression that will be injected into the effected 
        # statement. If a _block_ is given, it will be evaluated within
        # the expression.
        #
        def expression(&block)
          @expression.instance_eval(&block) if block
          return @expression
        end

        def sql(&block)
          @dialect.instance_eval(&block) if block
        end

        def compile
          injection = super.rstrip

          comment = lambda { [injection, '--'].join(space_token) }

          if (@close_parens && @close_string)
            if injection =~ /'\s*\)$/
              return injection.gsub(/'\s*\)$/,'')
            else
              return comment.call
            end
          end

          if @close_string
            if injection[-1..-1] == "'"
              return injection.chop
            else
              return comment.call
            end
          end

          return injection
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
          escape_value = ''

          if @close_string
            # format the escape string, since we are escaping out of a
            # string
            escape_value << format(@escape) if @escape
          else
            # do not format the escape string when we are not escaping
            # out of a string
            escape_value << @escape.to_s if @escape
          end

          if @close_string
            if escape_value[0..0] == "'"
              escape_value = escape_value[1..-1]
            else
              escape_value << "'"
            end
          end
           
          escape_value << ')' if @close_parens

          block.call(escape_value) unless escape_value.empty?

          return super(&block)
        end

        def each_token(&block)
          if @expression
            @expression.emit.each(&block)

            block.call(Token.separator)
          elsif @end_statement
            block.call(Token.separator)
          end

          return super(&block)
        end

        #
        # Relays missed method calls to the injected expression.
        #
        def method_missing(name,*arguments,&block)
          if @expression.public_methods(false).include?(name.to_s)
            return @expression.send(name,*arguments,&block)
          end

          return super(name,*arguments,&block)
        end

      end
    end
  end
end
