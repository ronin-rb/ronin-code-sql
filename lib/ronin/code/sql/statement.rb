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

require 'ronin/code/sql/expr'
require 'ronin/code/sql/field'
require 'ronin/code/sql/binary_expr'
require 'ronin/code/sql/unary_expr'
require 'ronin/code/sql/like_expr'
require 'ronin/code/sql/in'
require 'ronin/extensions/meta'

module Ronin
  module Code
    module SQL
      class Statement < Expr

        #
        # Creates a new Statement object connected to the specified
        # _program_. If a _block_ is given, it will be evaluated within
        # the newly created Statement object.
        #
        def initialize(program,&block)
          super(program)

          @clauses = []

          instance_eval(&block) if block
        end

        #
        # Returns the Array denoting the precedence of clauses provided by
        # the statement.
        #
        def self.clause_order
          @@clause_order ||= []
        end

        #
        # Returns the Hash of the clause names and the Clause classes
        # provided by the statement.
        #
        def self.clauses
          @@clauses ||= {}
        end

        #
        # Returns +true+ if the statement provides a clause with the
        # specified _name_, returns +false+ otherwise.
        #
        def self.has_clause?(name)
          self.clauses.has_key?(name.to_sym)
        end

        #
        # Returns an Array of unformatted tokens that represent the
        # statement.
        #
        def emit
          tokens = []

          @clauses.each do |tokens,clause|
            if clause
              tokens + clause.compile
            end
          end

          return tokens
        end

        #
        # Returns an formatted String representing the statement.
        #
        def to_s
          @program.compile_statement(self)
        end

        protected

        #
        # Adds a clause with the specified _name_, _clause_type_ and given
        # _options_ to the statement.
        #
        # _options_ may contain the following:
        # <tt>:before</tt>:: The name of the clause to take precedence
        #                    over.
        # <tt>:after</tt>:: The name of the clause which will take
        #                   precedence over the newly added clause.
        #
        def self.clause(name,clause_type,options={})
          name = name.to_sym
          index = self.clause_order.length

          if options[:before]
            index = self.clause_order.index(options[:before])
          elsif options[:after]
            index = self.clause_order.index(options[:after]) + 1
          end

          self.clause_order.insert(index,name)
          self.clauses[name] = clause_type

          class_def(name) do |*args|
            clause_index = self.class.clause_order.index(name)

            unless (@clauses[clause_index] && args.empty?)
              @clauses[clause_index] = self.clauses[name].new(*args)
            end

            return @clauses[clause_index]
          end

          return clause_type
        end

        def method_missing(symbol,*arguments)
          if arguments.empty?
            return @program.symbols[symbol]
          end

          raise(NoMethodError,symbol.id2name)
        end

      end
    end
  end
end
