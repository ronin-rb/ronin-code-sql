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
require 'ronin/code/symbol_table'

module Ronin
  module Code
    module SQL
      class Program

        # Name of the dialect
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

        def initialize(options={},&block)
          options[:dialect] ||= :common
          options[:symbols] ||= {}

          if options.has_key?(:multiline)
            @multiline = options[:multiline]
          else
            @multiline = true
          end

          if options.has_key?(:lowercase)
            @lowercase = options[:lowercase]
          else
            @lowercase = false
          end

          if options.has_key?(:less_parens)
            @less_parens = options[:less_parens]
          else
            @less_parens = false
          end

          @space = (options[:space] || ' ')
          @newline = (options[:newline] || "\n")

          @dialect = Dialect.get(options[:dialect]).new(options[:symbols])

          @dialect.instance_eval(&block) if block
        end

        def self.compile(options={},&block)
          self.new(options,&block).compile
        end

        def symbols
          @dialect.symbols
        end

        def select(*arguments,&block)
          @dialect.statement(:select,*arguments,&block)
        end

        def compile
          sql = ''

          each_string do |prev,current|
            sql << current
          end

          return sql
        end

        alias to_s compile

        protected

        def space_token
          if @space.kind_of?(Array)
            return @space[rand(@space.length)].to_s
          else
            return @space.to_s
          end
        end

        def preappend_space(str)
          "#{space_token}#{str}"
        end

        def append_space(str)
          "#{str}#{space_token}"
        end

        def newline_token
          return space_token unless @multiline

          if @newline.kind_of?(Array)
            return @newline[rand(@newline.length)].to_s
          else
            return @newline.to_s
          end
        end

        def format_string(data)
         "'" + data.to_s.sub("'","''") + "'"
        end

        def format_keyword(keyword)
          if keyword.is_separator?
            if @multiline
              return newline_token
            else
              return append_space(keyword)
            end
          elsif keyword.is_open_paren?
            if @less_parens
              return space_token
            else
              return preappend_space(keyword)
            end
          elsif keyword.is_open_paren?
            if @less_parens
              return space_token
            else
              return append_space(keyword)
            end
          elsif keyword.is_comma?
            if @less_parens
              return keyword.to_s
            else
              return append_space(keyword)
            end
          else
            if @lowercase
              return keyword.to_s.downcase
            else
              return keyword.to_s.upcase
            end
          end
        end

        def format_token(token)
          if token.kind_of?(Keyword)
            return format_keyword(token)
          elsif token.kind_of?(String)
            return format_string(token)
          else
            return token.to_s
          end
        end

        def each_token(&block)
          @dialect.each_token do |token|
            block.call(token)
          end

          return self
        end

        def each_string(&block)
          prev = nil

          each_token do |token|
            current = format_token(token)

            block.call(prev,current)
            prev = current
          end

          return self
        end

        def method_missing(name,*arguments,&block)
          if @dialect.has_statement?(name)
            return @dialect.enqueue_statement(name,*arguments,&block)
          end

          raise(NoMethodError,name.id2name)
        end

      end
    end
  end
end
