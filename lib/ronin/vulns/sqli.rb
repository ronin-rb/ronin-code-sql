#
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
#

require 'ronin/sql/errors'
require 'ronin/vulns/web'

module Ronin
  module Vulns
    #
    # The {SQLi} class represents SQL Injection vulnerabilities and implements
    # various tests for detecting them.
    #
    # @see https://github.com/ronin-ruby/ronin-sql/wiki/SQL-Injection-Tests
    #
    class SQLi < Web

      # SQL escape characters
      ESCAPE_CHARS = {
        'integer' => ' ',
        'statement' => ';'
      }

      # SQL String escape characters
      ESCAPE_QUOTES = {
        'single' => "'",
        'double' => '"',
        'back_tick' => '`'
      }

      # The type of escape technique to use
      property :escape, String, :set => %w[integer string statement]

      # The style of string quoting to escape
      property :escape_quotes, String, :set => %w[single double back_tick]

      def escape_string
        string = if self.escape == 'string'
                   # select the quote character
                   ESCAPE_QUOTES[self.escape_quotes]
                 else
                   # select the escape character
                   ESCAPE_CHARS[self.escape]
                 end

        # always append a single space after the escape character
        return "#{string} "
      end

      def injection_value(injection)
        if (injection.kind_of?(Hash) && injection[:escape])
          super(:append => (escape_string + injection[:escape].to_s))
        else
          super(injection)
        end
      end

      def vulnerable?
        !(
          space_filtering? ||
          numeric_filtering? ||
          alpha_filtering? ||
          sql_filtering?
        ) && (
          raw_injection? ||
          numeric_injection? ||
          string_injection? ||
          where_injection? ||
          order_by_injection?
        )
      end

      def sql_errors?
        tests = ["'", '"', '`']

        return tests.any? do |test|
          SQL::Errors.find(exploit(:insert => test))
        end
      end

      def numeric_filtering?
        never_changes?(:append => 'a')
      end

      def alpha_filtering?
        never_changes?(
          {:prepend => 'a'},
          {:prepend => 'A'}
        )
      end

      def space_filtering?
        never_changes?(
          {:prepend => ' '},
          {:prepend => "\t"},
          {:prepend => "\n"}
        )
      end

      def sql_filtering?
        never_changes?(
          {:prepend => ','},
          {:prepend => '.'},
          {:prepend => ';'},
          {:prepend => '('},
          {:prepend => ')'},
          {:prepend => "'"},
          {:prepend => '"'},
          {:prepend => '`'}
        )
      end

      def filters
        types = []

        types << :numeric if numeric_filtering?
        types << :alpha if alpha_filtering?
        types << :space if space_filtering?
        types << :sql if sql_filtering?

        return types
      end

      def raw_injection?
        never_changes?(
          {:append => '--'},
          {:prepend => 'ifnull(', :append => ',null)'},
          {:prepend => 'nullif(', :append => ',0)'}
        )
      end

      def numeric_injection?
        string = normal_value

        if (string && string =~ /\d+/)
          number = string.to_i

          never_changes?(
            {:append => '-0'},
            "#{number + 1}-1",
            {:prepend => 'abs(', :append => ')'},
            {:prepend => 'max(', :append => ',0)'}
          )
        end
      end

      def raw_string_injection?
        tests = []

        if (string = normal_value)
          tests << "substr(#{string},0,#{string.length})"

          if (string == string.downcase)
            tests << "lower(#{string})"
          end
        end

        return never_changes?(*tests)
      end

      def where_injection?
        everything = exploit(:escape => 'OR 1=1')
        nothing = exploit(:escape => 'AND 1=0')

        return (everything.body.length > nothing.body.length)
      end

      def order_by_injection?
        descending = exploit(:escape => 'DESC')
        ascending = exploit(:escape => 'ASC')

        return descending.body != ascending.body
      end

      def test!
        return false unless sql?

        self.escape = if numeric_injection?
                        'numeric'
                      elsif string_injection?
                        'string'
                      else
                        'statement'
                      end

        return true
      end

      protected

      def changes?(*tests)
        tests.any? do |test|
          normal_response.body != exploit(test).body
        end
      end

      def never_changes?(*tests)
        tests.all? do |test|
          normal_response.body == exploit(test).body
        end
      end

    end
  end
end
