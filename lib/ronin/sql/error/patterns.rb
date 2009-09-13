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

require 'ronin/sql/error/pattern'

module Ronin
  module SQL
    module Error
      Error.pattern :ms_sql do |p|
        p.dialect = :ms
        p.recognize /Microsoft SQL Native Client/
        p.recognize /Microsoft OLE DB Provider for SQL Server/
        p.recognize /Microsoft OLE DB Provider for ODBC Drivers.*\[Microsoft\]\[ODBC SQL Server Driver\]/
      end

      Error.pattern :ms_access do |p|
        p.dialect = :ms
        p.recognize /Microsoft OLE DB Provider for ODBC Drivers.*\[Microsoft\]\[ODBC Access Driver\]/
        p.recognize /\[Microsoft\]\[ODBC Microsoft Access Driver\] Syntax error/
      end

      Error.pattern :ms_jetdb do |p|
        p.dialect = :ms
        p.recognize /Microsoft JET Database Engine/
      end

      Error.pattern :ms_adodb do |p|
        p.dialect = :ms
        p.recognize /ADODB.Command.*error/
      end

      Error.pattern :asp_net do |p|
        p.dialect = :common
        p.recognize /Server Error.*System\.Data\.OleDb\.OleDbException/
      end

      Error.pattern :mysql do |p|
        p.dialect = :mysql
        p.recognize /Warning.*supplied argument is not a valid MySQL result/
        p.recognize /Warning.*mysql_.*\(\)/
        p.recognize /You have an error in your SQL syntax.*(on|at) line/
      end

      Error.pattern :php do |p|
        p.dialect = :common
        p.recognize /Warning.*failed to open stream/
        p.recognize /Fatal Error.*(on|at) line/
      end

      Error.pattern :oracle do |p|
        p.dialect = :oracle
        p.recognize /ORA-[0-9][0-9][0-9][0-9]/
      end

      Error.pattern :jdbc do |p|
        p.dialect = :common
        p.recognize /Invalid SQL statement or JDBC/
      end

      Error.pattern :java_servlet do |p|
        p.dialect = :common
        p.recognize /javax\.servlet\.ServletException/
      end

      Error.pattern :apache_tomcat do |p|
        p.dialect = :common
        p.recognize /org\.apache\.jasper\.JasperException/
      end

      Error.pattern :vb_runtime do |p|
        p.dialect = :common
        p.recognize /Microsoft VBScript runtime/
      end

      Error.pattern :vb_asp do |p|
        p.dialect = :common
        p.recognize /Type mismatch/
      end
    end
  end
end
