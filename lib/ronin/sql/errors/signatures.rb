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
      Errors.signature do |sig|
        sig.software = 'MSSQL'
        sig.vendor = 'Microsoft'
        sig.dialect = :mssql

        sig.recognize /Microsoft SQL Native Client/
        sig.recognize /Microsoft OLE DB Provider for SQL Server/
        sig.recognize /Microsoft OLE DB Provider for ODBC Drivers.*\[Microsoft\]\[ODBC SQL Server Driver\]/
      end

      Errors.signature do |sig|
        sig.software = 'Microsoft Access'
        sig.vendor = 'Microsoft'
        sig.dialect = :mssql

        sig.recognize /Microsoft OLE DB Provider for ODBC Drivers.*\[Microsoft\]\[ODBC Access Driver\]/
        sig.recognize /\[Microsoft\]\[ODBC Microsoft Access Driver\] Syntax error/
      end

      Errors.signature do |sig|
        sig.software = 'Microsoft Jet Database Engine'
        sig.vendor = 'Microsoft'
        sig.dialect = :mssql

        sig.recognize /Microsoft JET Database Engine/
      end

      Errors.signature do |sig|
        sig.software = 'ActiveX Data Objects Database'
        sig.vendor = 'Microsoft'
        sig.dialect = :mssql

        sig.recognize /ADODB\.(Field|Command).*error\s+'[0-9a-f]+'/
      end

      Errors.signature do |sig|
        sig.software = 'ASP.NET'
        sig.vendor = 'Microsoft'
        sig.dialect = :common

        sig.recognize /Server Error.*System\.Data\.OleDb\.OleDbException/
      end

      Errors.signature do |sig|
        sig.software = 'MySQL Server'
        sig.vendor = 'MySQL'
        sig.dialect = :mysql

        sig.recognize /Warning.*supplied argument is not a valid MySQL result/
        sig.recognize /Warning.*mysql_.*\(\)/
        sig.recognize /You have an error in your SQL syntax.*(on|at) line/
      end

      Errors.signature do |sig|
        sig.software = 'PHP'
        sig.dialect = :common

        sig.recognize /Warning.*failed to open stream/
        sig.recognize /Fatal Error.*(on|at) line/
      end

      Errors.signature do |sig|
        sig.software = 'Oracle Database'
        sig.vendor = 'Oracle'
        sig.dialect = :oracle

        sig.recognize /ORA-[0-9][0-9][0-9][0-9]/
      end

      Errors.signature do |sig|
        sig.software = 'Java Database Connectivity'
        sig.vendor = 'Oracle'
        sig.dialect = :common

        sig.recognize /Invalid SQL statement or JDBC/
      end

      Errors.signature do |sig|
        sig.software = 'Java Servlet'
        sig.vendor = 'Oracle'
        sig.dialect = :common

        sig.recognize /javax\.servlet\.ServletException/
      end

      Errors.signature do |sig|
        sig.software = 'Tomcat'
        sig.vendor = 'Apache'
        sig.dialect = :common

        sig.recognize /org\.apache\.jasper\.JasperException/
      end

      Errors.signature do |sig|
        sig.software = 'Visual Basic'
        sig.vendor = 'Microsoft'
        sig.dialect = :common

        sig.recognize /Microsoft VBScript runtime/
      end

      Errors.signature do |sig|
        sig.software = 'Visual Basic ASP'
        sig.vendor = 'Microsoft'
        sig.dialect = :common

        sig.recognize /Type mismatch/
      end
    end
  end
end
