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

require 'ronin/sql/errors/pattern'

module Ronin
  module SQL
    module Errors
      Errors.pattern :ms_sql do |p|
        p.dialect = :ms
        p.recognize /Microsoft SQL Native Client/
        p.recognize /Microsoft OLE DB Provider for SQL Server/
        p.recognize /Microsoft OLE DB Provider for ODBC Drivers.*\[Microsoft\]\[ODBC SQL Server Driver\]/
      end

      Errors.pattern :ms_access do |p|
        p.dialect = :ms
        p.recognize /Microsoft OLE DB Provider for ODBC Drivers.*\[Microsoft\]\[ODBC Access Driver\]/
        p.recognize /\[Microsoft\]\[ODBC Microsoft Access Driver\] Syntax error/
      end

      Errors.pattern :ms_jetdb do |p|
        p.dialect = :ms
        p.recognize /Microsoft JET Database Engine/
      end

      Errors.pattern :ms_adodb do |p|
        p.dialect = :ms
        p.recognize /ADODB.Command.*error/
      end

      Errors.pattern :asp_net do |p|
        p.dialect = :common
        p.recognize /Server Error.*System\.Data\.OleDb\.OleDbException/
      end

      Errors.pattern :mysql do |p|
        p.dialect = :mysql
        p.recognize /Warning.*supplied argument is not a valid MySQL result/
        p.recognize /Warning.*mysql_.*\(\)/
        p.recognize /You have an error in your SQL syntax.*(on|at) line/
      end

      Errors.pattern :php do |p|
        p.dialect = :common
        p.recognize /Warning.*failed to open stream/
        p.recognize /Fatal Error.*(on|at) line/
      end

      Errors.pattern :oracle do |p|
        p.dialect = :oracle
        p.recognize /ORA-[0-9][0-9][0-9][0-9]/
      end

      Errors.pattern :jdbc do |p|
        p.dialect = :common
        p.recognize /Invalid SQL statement or JDBC/
      end

      Errors.pattern :java_servlet do |p|
        p.dialect = :common
        p.recognize /javax\.servlet\.ServletException/
      end

      Errors.pattern :apache_tomcat do |p|
        p.dialect = :common
        p.recognize /org\.apache\.jasper\.JasperException/
      end

      Errors.pattern :vb_runtime do |p|
        p.dialect = :common
        p.recognize /Microsoft VBScript runtime/
      end

      Errors.pattern :vb_asp do |p|
        p.dialect = :common
        p.recognize /Type mismatch/
      end
    end
  end
end
