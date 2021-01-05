#
# Ronin SQL - A Ruby DSL for crafting SQL Injections.
#
# Copyright (c) 2007-2013 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-sql.
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

require 'ronin/sql/statement_list'
require 'ronin/sql/injection'

module Ronin
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
    #   # => #<Ronin::SQL::StatementList: SELECT (1,2,3,4,id) FROM users>
    #
    # @api public
    #
    def sql(&block)
      StatementList.new(&block)
    end

    #
    # Creates a new SQL injection (SQLi)
    #
    # @param [Hash] options
    #   Additional injection options.
    #
    # @option options [:integer, :decimal, :string, :column] :escape
    #   The type of element to escape out of.
    #
    # @option options [Boolean] :terminate
    #   Specifies whether to terminate the SQLi with a comment.
    #
    # @option options [String, Symbol, Integer] :place_holder
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
    #   # => #<Ronin::SQL::Injection: 1 AND 1=1; SELECT (1,2,3,4,id) FROM users; SELECT (1,2,3,4,id) FROM users>
    #
    # @api public
    #
    def sqli(options={},&block)
      Injection.new(options,&block)
    end

  end
end
