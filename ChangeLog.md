### 2.0.0 / 2023-02-01

* Require `ruby` >= 3.0.0.
* Added [ronin-support] ~> 0.1 as a dependency.
* Renmaed `ronin/formatting/sql` to `ronin/support/encoding/sql` and moved it
  back into [ronin-support].

[ronin-support]: https://github.com/ronin-rb/ronin-support#readme

### 1.1.0 / 2013-01-22

* Added `Ronin::SQL::InjectionExpr`, so that statements specified within
  `and { }`, `or { }` blocks would not be appending to the
  `Ronin::SQL::Injection` object.
* Made `Ronin::SQL::Field` emittable.
* Added `Ronin::SQL::Emitter#emit_argument`, so that any sub-statements will
  be wrapped in `( )`.
* Improved `Ronin::SQL::Emitter#emit_field`.
* Fixed `Ronin::SQL::Emitter#emit` to pass `Ronin::SQL::Function`s to
  `Ronin::SQL::Emitter#emit_function`.

### 1.0.0 / 2013-01-21

* Require [Ruby] >= 1.9.1.
* No longer require ronin.
* No longer require ronin-web.
* Added `String#sql_unescape`.
* Moved `String#sql_escape`, `String#sql_encode` and `String#sql_decode`
  from [ronin-support].
* Refactored the `Ronin::SQL SQL` DSL to be more like
  [ARel](https://github.com/rails/arel#readme).
  * Moved the DSL from `Ronin::Code::SQL` into `Ronin::SQL`.
* Removed `Ronin::SQL::Error`.
* Removed `String#sql_error`.
* Removed `String#sql_error?`.
* Removed `URI::HTTP.has_sql_errors?`.
* Removed `URI::HTTP.sql_error`.
* Removed `URI::HTTP.sql_errors`.

### 0.2.4 / 2009-09-24

* Require ronin >= 0.3.0.
* Require ronin-web >= 0.2.0.
* Require rspec >= 1.1.12.
* Require yard >= 0.2.3.5.
* Updated the project summary and 3-point description for Ronin SQL.
* Moved to YARD based documentation.
* Fixed a formatting issue in the README.txt file, which was causing RDoc
  to crash.

### 0.2.3 / 2009-07-02

* Use Hoe >= 2.0.0.
* Require ronin >= 0.2.4.
* Require ronin-web >= 0.1.3.
* Use Ronin::Scanners::Scanner to define the scanner for finding
  `Ronin::SQL::Injection` objects for URI::HTTP urls.
* Added more specs.

### 0.2.2 / 2009-01-22

* Depend on the new ronin-web library.
* Replace Hpricot with Nokogiri.
* Use the new Ronin::Web::Spider, instead of directly using Spidr.
* Use the new Nokogiri extensions from ronin-web.

### 0.2.1 / 2009-01-09

* Added missing files to the Manifest.

### 0.2.0 / 2009-01-08

* Require ronin >= 0.1.3.
* Refactored `Ronin::Code::SQL`.
  * Implemented a token emitter system.
  * Support common SQL expression modifiers.
  * Support common SQL clauses.
  * Allow for injecting arbitrary SQL clauses.
  * Added more SQL Injection test generators.
    * all_rows: `OR 1 = 1`
    * exact_rows: `AND 1 = 1`
    * no_rows: `AND 1 = 0`
    * has_column?(column): `OR column IS NOT NULL`
    * has_table?(table): `AND (SELECT FROM table count(*) == 1)`
    * uses_column?(column): `GROUP BY column HAVING 1 = 1`
    * uses_table?(table): `OR table IS NOT NULL`
* Removed references to `Ronin::Vulnerable`.
* Added more specs:
  * Specs for most of `Ronin::Code::SQL`.
  * Specs on `Ronin::SQL::Error` and the SQL encoding/decoding extensions for
    the String class.

### 0.1.1 / 2008-09-28

* Trivial bug fix to `URI::HTTP#sql_errors`.

### 0.1.0 / 2007-12-23

* Initial release.
* Supports SQL code generation.
* Supports obfuscation of SQL code.
* Supports SQL Injection code generation.

[Ruby]: http://www.ruby-lang.org/
