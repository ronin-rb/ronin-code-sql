# frozen_string_literal: true
#
# ronin-code-sql - A Ruby DSL for crafting SQL Injections.
#
# Copyright (c) 2007-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# ronin-code-sql is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-code-sql is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-code-sql.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/code/sql/statement_list'
require 'ronin/code/sql/injection'

module Ronin
  module Code
    #
    # Provides a Domain Specific Language (DSL) for crafting complex
    # {StatementList SQL} and SQL {Injection Injections} (SQLi).
    #
    # @see http://en.wikipedia.org/wiki/SQL_injection
    #
    module SQL

      #
      # Creates a new SQL statement list.
      #
      # @yield [(statements)]
      #   If a block is given, it will be evaluated within the statement list.
      #   If the block accepts an argument, the block will be called with the
      #   new statement list.
      #
      # @yieldparam [StatementList] statements
      #   The new statement list.
      #
      # @return [StatementList]
      #   The new SQL statement list.
      #
      # @example
      #   sql { select(1,2,3,4,id).from(users) }
      #   # => #<Ronin::Code::SQL::StatementList: SELECT (1,2,3,4,id) FROM users>
      #
      # @api public
      #
      def sql(&block)
        StatementList.new(&block)
      end

      #
      # Creates a new SQL injection (SQLi)
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments for {Injection#initialize}.
      #
      # @option kwargs [:integer, :decimal, :string, :column] :escape
      #   The type of element to escape out of.
      #
      # @option kwargs [Boolean] :terminate
      #   Specifies whether to terminate the SQLi with a comment.
      #
      # @option kwargs [String, Symbol, Integer] :place_holder
      #   Place-holder data.
      #
      # @yield [(injection)]
      #   If a block is given, it will be evaluated within the injection.
      #   If the block accepts an argument, the block will be called with the
      #   new injection.
      #
      # @yieldparam [Injection] injection
      #   The new injection.
      #
      # @return [Injection]
      #   The new SQL injection.
      #
      # @example
      #   sqli { self.and { 1 == 1 }.select(1,2,3,4,id).from(users) }
      #   # => #<Ronin::Code::SQL::Injection: 1 AND 1=1; SELECT (1,2,3,4,id) FROM users; SELECT (1,2,3,4,id) FROM users>
      #
      # @api public
      #
      def sqli(**kwargs,&block)
        Injection.new(**kwargs,&block)
      end

    end
  end
end
