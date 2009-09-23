= Ronin SQL

* http://ronin.rubyforge.org/sql/
* http://github.com/postmodern/ronin-sql
* irc.freenode.net #ronin
* Postmodern (postmodern.mod3 at gmail.com)

== DESCRIPTION:

Ronin SQL is a Ruby library for Ronin that provids support for SQL related
security tasks.

Ronin is a Ruby platform for exploit development and security research.
Ronin allows for the rapid development and distribution of code, exploits
or payloads over many common Source-Code-Management (SCM) systems.

=== Ruby

Ronin's Ruby environment allows security researchers to leverage Ruby with
ease. The Ruby environment contains a multitude of convenience methods
for working with data in Ruby, a Ruby Object Database, a customized Ruby
Console and an extendable command-line interface.

=== Extend

Ronin's more specialized features are provided by additional Ronin
libraries, which users can choose to install. These libraries can allow
one to write and run Exploits and Payloads, scan for PHP vulnerabilities,
perform Google Dorks  or run 3rd party scanners.

=== Publish

Ronin allows users to publish and share code, exploits, payloads or other
data via Overlays. Overlays are directories of code and data that can be
hosted on any SVN, Hg, Git or Rsync server. Ronin makes it easy to create,
install or update Overlays.

== FEATURES:

* Provides an Domain Specific Language (DSL) for crafting normal SQL and
  SQL injections.
* Provides tests for finding SQL injections.

== SYNOPSIS:

* Start the Ronin Console with Ronin SQL preloaded:

    $ ronin-sql

== EXAMPLES:

* Generate valid SQL using the Ronin SQL DSL:

    Code.sql {
      select(:from => :users, :where => (name == 'bob'))
    }.to_s
    # => "SELECT * FROM users WHERE name = 'bob'"

* Generate valid SQL injections using the Ronin SQL injection DSL:

    Code.sql_injection {
      escape_string { has_table?(:users) }
    }.to_s
    # => "' AND (SELECT count(*) FROM users) = 1 --"

* Test a URL for SQL Injection (SQLi):

    require 'ronin/sql'

    url = URI('http://redteatrosalternativos.com/_05enlaces/links/phpHoo3.php?viewCat=1')
    url.has_sqli?
    # => true

* Get the first viable SQLi vulnerability:

    url.first_sqli
    # => #<Ronin::SQL::Injection:0x67d6d38cba60 @http_method=:get, @url=#<URI::HTTP:0x67d6d8697190 URL:http://redteatrosalternativos.com/_05enlaces/links/phpHoo3.php?viewCat=1>, @params={:http_method=>:get}, @sql_options={:escape=>"1"}, @param="viewCat">

* Scan a URL for SQLi vulnerabilities:

    url.sqli_scan
    # => [#<Ronin::SQL::Injection:0x67d6d38792d8 @http_method=:get, @url=#<URI::HTTP:0x67d6d8697190 URL:http://redteatrosalternativos.com/_05enlaces/links/phpHoo3.php?viewCat=1>, @params={:http_method=>:get}, @sql_options={:escape=>"1"}, @param="viewCat">]

== REQUIREMENTS:

* {ronin}[http://ronin.rubyforge.org/] >= 0.1.2
* {ronin-web}[http://ronin.rubyforge.org/web/] >= 0.1.0

== INSTALL:

  $ sudo gem install ronin-sql

== LICENSE:

Ronin SQL - A Ruby library for Ronin that provids support for SQL related
security tasks.

Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
