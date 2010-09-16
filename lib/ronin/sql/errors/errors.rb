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

require 'ronin/sql/errors/signature'

module Ronin
  module SQL
    module Errors
      #
      # All defined SQL Error Signatures.
      #
      # @return [Array<Signature>]
      #
      # @since 0.3.0
      #
      def Errors.signatures
        @@ronin_sql_error_signatures ||= []
      end

      #
      # Defines a new SQL Error Signature.
      #
      # @yield [sig]
      #   The given block will be passed the new SQL Error Signature.
      #
      # @yieldparam [Signature] sig
      #   The new SQL Error Signature.
      #
      # @since 0.3.0
      #
      def Errors.signature(&block)
        Errors.signatures << Signature.new(&block)
      end

      #
      # Finds the first SQL Error that matches a known SQL Error Signature.
      #
      # @param [String] data
      #   The data to apply SQL Error Signatures to.
      #
      # @return [Error, nil]
      #   The first detected SQL Error.
      #
      # @since 0.3.0
      #
      def Errors.find(data)
        Errors.signatures.each do |sig|
          error = sig.match(data)

          return error if error
        end

        return nil
      end
    end
  end
end
