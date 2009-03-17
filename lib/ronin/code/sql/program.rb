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

require 'ronin/code/sql/dialect'
require 'ronin/code/sql/common_dialect'

require 'chars/char_set'

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

          @space = Chars::CharSet.new(options[:space] || ' ')
          @newline = Chars::CharSet.new(options[:newline] || "\n")

          @dialect = Dialect.get(options[:dialect]).new(options[:symbols])

          instance_eval(&block) if block
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
          sql = []
          stmt = ['']
          prev = nil

          each_string do |current|
            if current == ';'
              sql << stmt
              stmt = ['']
            elsif current == '('
              next if @less_parens

              stmt << current
            elsif current == ')'
              next if @less_parens

              stmt.last << current
            elsif (current == ',' || prev == '(')
              stmt.last << current
            elsif prev == ','
              if @less_parens
                stmt.last << current
              else
                stmt << current
              end
            else
              stmt << current
            end

            prev = current
          end

          sql_string = ''

          sql.each_with_index do |stmt,stmt_index|
            stmt_string = ''

            stmt.each_with_index do |token,token_index|
              unless token.empty?
                sql_string << token

                unless token_index == (stmt.length - 1)
                  sql_string << space_token
                end
              end
            end

            sql_string << stmt_string

            unless stmt_index == (sql.length - 1)
              if @multiline
                sql_string << newline_token
              else
                sql_string << ';'
                sql_string << space_token
              end
            end
          end

          return sql_string
        end

        alias to_s compile

        protected

        def space_token
          @space.random_char
        end

        def newline_token
          @newline.random_char
        end

        def format_string(data)
         "'" + data.to_s.sub("'","''") + "'"
        end

        def format_token(token)
          token = token.to_s

          if @lowercase
            token.downcase!
          else
            token.upcase!
          end

          return token
        end

        def format(token)
          if token.kind_of?(Token)
            return format_token(token)
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
          each_token do |token|
            block.call(format(token))
          end

          return self
        end

        def method_missing(name,*arguments,&block)
          if @dialect.has_statement?(name)
            return @dialect.enqueue_statement(name,*arguments,&block)
          elsif @dialect.methods.include?(name.to_s)
            return @dialect.send(name,*arguments,&block)
          elsif (arguments.empty? && block.nil?)
            if @dialect.symbols.has_symbol?(name)
              return @dialect.symbols[name]
            end
          end

          raise(NoMethodError,name.id2name)
        end

      end
    end
  end
end
