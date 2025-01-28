# frozen_string_literal: true
#
# ronin-code-sql - A Ruby DSL for crafting SQL Injections.
#
# Copyright (c) 2007-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require_relative 'function'

module Ronin
  module Code
    module SQL
      #
      # Methods for creating common SQL {Function Functions}.
      #
      # @api public
      #
      module Functions
        #
        # @!group Aggregate Functions
        #

        #
        # The `COUNT` function.
        #
        # @param [Field, Symbol] field
        #   The field to aggregate.
        #
        # @return [Function]
        #   The new function.
        #
        def count(field=:*)
          Function.new(:COUNT,field)
        end

        #
        # The `MAX` function.
        #
        # @param [Field, Symbol] field
        #   The field to aggregate.
        #
        # @return [Function]
        #   The new function.
        #
        def max(field)
          Function.new(:MAX,field)
        end

        #
        # The `MIN` function.
        #
        # @param [Field, Symbol] field
        #   The field to aggregate.
        #
        # @return [Function]
        #   The new function.
        #
        def min(field)
          Function.new(:MIN,field)
        end

        #
        # The `AVG` function.
        #
        # @param [Field, Symbol] field
        #   The field to aggregate.
        #
        # @return [Function]
        #   The new function.
        #
        def avg(field)
          Function.new(:AVG,field)
        end

        #
        # The `SUM` function.
        #
        # @param [Field, Symbol] field
        #   The field to aggregate.
        #
        # @return [Function]
        #   The new function.
        #
        def sum(field)
          Function.new(:SUM,field)
        end

        #
        # The `SQRT` function.
        #
        # @param [Field, Function, Symbol, Numeric] field
        #   The field to aggregate.
        #
        # @return [Function]
        #   The new function.
        #
        def sqrt(field)
          Function.new(:SQRT,field)
        end

        #
        # The `RAND` function.
        #
        # @param [Field, Symbol] field
        #   The field to aggregate.
        #
        # @return [Function]
        #   The new function.
        #
        def rand(field)
          Function.new(:RAND,field)
        end

        #
        # @!group Numeric Functions
        #

        #
        # The `ABS` function.
        #
        # @param [Field, Function, Symbol, Numeric] x
        #
        # @return [Function]
        #   The new function.
        #
        def abs(x)
          Function.new(:ABS,x)
        end

        #
        # The `ACOS` function.
        #
        # @param [Field, Function, Symbol, Numeric] x
        #
        # @return [Function]
        #   The new function.
        #
        def acos(x)
          Function.new(:ACOS,x)
        end

        #
        # The `ASIN` function.
        #
        # @param [Field, Function, Symbol, Numeric] x
        #
        # @return [Function]
        #   The new function.
        #
        def asin(x)
          Function.new(:ASIN,x)
        end

        #
        # The `ATAN` function.
        #
        # @param [Field, Function, Symbol, Numeric] x
        #
        # @return [Function]
        #   The new function.
        #
        def atan(x)
          Function.new(:ATAN,x)
        end

        #
        # The `ATAN2` function.
        #
        # @param [Field, Function, Symbol, Numeric] x
        #
        # @param [Field, Function, Symbol, Numeric] y
        #
        # @return [Function]
        #   The new function.
        #
        def atan2(y,x)
          Function.new(:ATAN2,y,x)
        end

        #
        # The `BIT_AND` function.
        #
        # @param [Field, Function, Symbol, Numeric] x
        #
        # @return [Function]
        #   The new function.
        #
        def bit_and(x)
          Function.new(:BIT_AND,x)
        end

        #
        # The `BIT_COUNT` function.
        #
        # @param [Field, Function, Symbol, Numeric] x
        #
        # @return [Function]
        #   The new function.
        #
        def bit_count(x)
          Function.new(:BIT_COUNT,x)
        end

        #
        # The `BIT_OR` function.
        #
        # @param [Field, Function, Symbol, Numeric] x
        #
        # @return [Function]
        #   The new function.
        #
        def bit_or(x)
          Function.new(:BIT_OR,x)
        end

        #
        # The `CEIL` function.
        #
        # @param [Field, Function, Symbol, Numeric] x
        #
        # @return [Function]
        #   The new function.
        #
        def ceil(x)
          Function.new(:CEIL,x)
        end

        #
        # The `CEILING` function.
        #
        # @param [Field, Function, Symbol, Numeric] x
        #
        # @return [Function]
        #   The new function.
        #
        def ceiling(x)
          Function.new(:CEILING,x)
        end

        #
        # The `COS` function.
        #
        # @param [Field, Function, Symbol, Numeric] x
        #
        # @return [Function]
        #   The new function.
        #
        def cos(x)
          Function.new(:COS,x)
        end

        #
        # The `COT` function.
        #
        # @param [Field, Function, Symbol, Numeric] x
        #
        # @return [Function]
        #   The new function.
        #
        def cot(x)
          Function.new(:COT,x)
        end

        #
        # The `DEGREES` function.
        #
        # @param [Field, Function, Symbol, Numeric] x
        #
        # @return [Function]
        #   The new function.
        #
        def degrees(x)
          Function.new(:DEGREES,x)
        end

        #
        # The `EXP` function.
        #
        # @param [Field, Function, Symbol, Numeric] x
        #
        # @return [Function]
        #   The new function.
        #
        def exp(x)
          Function.new(:EXP,x)
        end

        #
        # The `FLOOR` function.
        #
        # @param [Field, Function, Symbol, Numeric] x
        #
        # @return [Function]
        #   The new function.
        #
        def floor(x)
          Function.new(:FLOOR,x)
        end

        #
        # The `FORMAT` function.
        #
        # @param [Field, Function, Symbol, String, Numeric] value
        #
        # @param [Field, Function, Symbol, String] pattern
        #
        # @return [Function]
        #   The new function.
        #
        def format(value,pattern)
          Function.new(:FORMAT,value,pattern)
        end

        #
        # The `GREATEST` function.
        #
        # @param [Array<Field, Function, Symbol, Numeric>] values
        #
        # @return [Function]
        #   The new function.
        #
        def greatest(*values)
          Function.new(:GREATEST,*values)
        end

        #
        # The `INTERVAL` function.
        #
        # @param [Array<Field, Function, Symbol, Numeric>] values
        #
        # @return [Function]
        #   The new function.
        #
        def interval(*values)
          Function.new(:INTERVAL,*values)
        end

        #
        # The `LEAST` function.
        #
        # @param [Array<Field, Function, Symbol, Numeric>] values
        #
        # @return [Function]
        #   The new function.
        #
        def least(*values)
          Function.new(:LEAST,*values)
        end

        #
        # The `LOG` function.
        #
        # @param [Field, Function, Symbol, Numeric, nil] b
        #
        # @param [Field, Function, Symbol, Numeric] x
        #
        # @return [Function]
        #   The new function.
        #
        def log(b=nil,x)
          if b then Function.new(:LOG,b,x)
          else      Function.new(:LOG,x)
          end
        end

        #
        # The `LOG10` function.
        #
        # @param [Field, Function, Symbol, Numeric] x
        #
        # @return [Function]
        #   The new function.
        #
        def log10(x)
          Function.new(:LOG10,x)
        end

        #
        # The `MOD` function.
        #
        # @param [Field, Function, Symbol, Numeric] n
        #
        # @param [Field, Function, Symbol, Numeric] m
        #
        # @return [Function]
        #   The new function.
        #
        def mod(n,m)
          Function.new(:MOD,n,m)
        end

        #
        # The `PI` function.
        #
        # @return [Function]
        #   The new function.
        #
        def pi
          Function.new(:PI)
        end

        #
        # The `POW` function.
        #
        # @param [Field, Function, Symbol, Numeric] x
        #
        # @param [Field, Function, Symbol, Numeric] y
        #
        # @return [Function]
        #   The new function.
        #
        def pow(x,y)
          Function.new(:POW,x,y)
        end

        #
        # The `POWER` function.
        #
        # @param [Field, Function, Symbol, Numeric] x
        #
        # @param [Field, Function, Symbol, Numeric] y
        #
        # @return [Function]
        #   The new function.
        #
        def power(x,y)
          Function.new(:POWER,x,y)
        end

        #
        # The `RADIANS` function.
        #
        # @param [Field, Function, Symbol, Numeric] x
        #
        # @return [Function]
        #   The new function.
        #
        def radians(x)
          Function.new(:RADIANS,x)
        end

        #
        # The `RANDOM` function.
        #
        # @return [Function]
        #   The new function.
        #
        def random
          Function.new(:RANDOM)
        end

        #
        # The `ROUND` function.
        #
        # @param [Field, Function, Symbol, Numeric] x
        #
        # @param [Field, Function, Symbol, Numeric, nil] d
        #
        # @return [Function]
        #   The new function.
        #
        def round(x,d=nil)
          if d then Function.new(:ROUND,x,d)
          else      Function.new(:ROUND,x)
          end
        end

        #
        # The `SIGN` function.
        #
        # @param [Field, Function, Symbol, Numeric] x
        #
        # @return [Function]
        #   The new function.
        #
        def sign(x)
          Function.new(:SIGN,x)
        end

        #
        # The `SIN` function.
        #
        # @param [Field, Function, Symbol, Numeric] x
        #
        # @return [Function]
        #   The new function.
        #
        def sin(x)
          Function.new(:SIN,x)
        end

        #
        # The `STD` function.
        #
        # @param [Field, Symbol] field
        #
        # @return [Function]
        #   The new function.
        #
        def std(field)
          Function.new(:STD,field)
        end

        #
        # The `STDDEV` function.
        #
        # @param [Field, Symbol] field
        #
        # @return [Function]
        #   The new function.
        #
        def stddev(field)
          Function.new(:STDDEV,field)
        end

        #
        # The `TAN` function.
        #
        # @param [Field, Function, Symbol, Numeric] x
        #
        # @return [Function]
        #   The new function.
        #
        def tan(x)
          Function.new(:TAN,x)
        end

        #
        # The `TRUNCATE` function.
        #
        # @param [Field, Function, Symbol, Numeric] x
        #
        # @param [Field, Function, Symbol, Numeric] d
        #
        # @return [Function]
        #   The new function.
        #
        def truncate(x,d)
          Function.new(:TRUNCATE,x,d)
        end

        #
        # @!group String Functions
        #

        #
        # The `ASCII` function.
        #
        # @param [Field, Function, Symbol, String] string
        #
        # @return [Function]
        #   The new function.
        #
        def ascii(string)
          Function.new(:ASCII,string)
        end

        #
        # The `BIN` function.
        #
        # @param [Field, Function, Symbol, Numeric] n
        #
        # @return [Function]
        #   The new function.
        #
        def bin(n)
          Function.new(:BIN,n)
        end

        #
        # The `BIT_LENGTH` function.
        #
        # @param [Field, Function, Symbol, String] string
        #
        # @return [Function]
        #   The new function.
        #
        def bit_length(string)
          Function.new(:BIT_LENGTH,string)
        end

        #
        # The `CHAR` function.
        #
        # @param [Array<Numeric>] bytes
        #
        # @return [Function]
        #   The new function.
        #
        def char(*bytes)
          Function.new(:CHAR,*bytes)
        end

        #
        # The `CHAR_LENGTH` function.
        #
        # @param [Field, Function, Symbol, String] string
        #
        # @return [Function]
        #   The new function.
        #
        def char_length(string)
          Function.new(:CHAR_LENGTH,string)
        end

        #
        # The `CHARACTER_LENGTH` function.
        #
        # @param [Field, Function, Symbol, String] string
        #
        # @return [Function]
        #   The new function.
        #
        def character_length(string)
          Function.new(:CHARACTER_LENGTH,string)
        end

        #
        # The `CONCAT` function.
        #
        # @param [Array<Field, Function, Symbol, String>] strings
        #
        # @return [Function]
        #   The new function.
        #
        def concat(*strings)
          Function.new(:CONCAT,*strings)
        end

        #
        # The `CONCAT_WS` function.
        #
        # @param [Field, Function, Symbol, String] separator
        #
        # @param [Array<Field, Function, Symbol, String>] strings
        #
        # @return [Function]
        #   The new function.
        #
        def concat_ws(separator,*strings)
          Function.new(:CONCAT_WS,separator,*strings)
        end

        #
        # The `CONV` function.
        #
        # @param [Field, Function, Symbol, Numeric] number
        #
        # @param [Field, Function, Symbol, Numeric] from_base
        #
        # @param [Field, Function, Symbol, Numeric] to_base
        #
        # @return [Function]
        #   The new function.
        #
        def conv(number,from_base,to_base)
          Function.new(:CONV,number,from_base,to_base)
        end

        #
        # The `ELT` function.
        #
        # @param [Field, Function, Symbol, Numeric] index
        #
        # @param [Array<Field, Function, Symbol, String>] strings
        #
        # @return [Function]
        #   The new function.
        #
        def elt(index,*strings)
          Function.new(:ELT,index,*strings)
        end

        #
        # The `EXPORT_SET` function.
        #
        # @param [Field, Function, Symbol, Numeric] bits
        #
        # @param [Field, Function, Symbol, String] on
        #
        # @param [Field, Function, Symbol, String] off
        #
        # @param [Field, Function, Symbol, String, nil] separator
        #
        # @param [Field, Function, Symbol, Numeric, nil] number_of_bits
        #
        # @return [Function]
        #   The new function.
        #
        def export_set(bits,on,off,separator=nil,number_of_bits=nil)
          if (separator && number_of_bits)
            Function.new(:EXPORT_SET,bits,on,off,separator,number_of_bits)
          elsif separator
            Function.new(:EXPORT_SET,bits,on,off,separator)
          else
            Function.new(:EXPORT_SET,bits,on,off)
          end
        end

        #
        # The `FIELD` function.
        #
        # @param [Array<Field, Function, Symbol, String>] strings
        #
        # @return [Function]
        #   The new function.
        #
        def field(*strings)
          Function.new(:FIELD,*strings)
        end

        #
        # The `FIND_IN_SET` function.
        #
        # @param [Field, Function, Symbol, String] string
        #
        # @param [Array<Field, Function, Symbol, String>] set
        #
        # @return [Function]
        #   The new function.
        #
        def find_in_set(string,set)
          Function.new(:FIND_IN_SET,string,set)
        end

        #
        # The `GLOB` function.
        #
        # @param [Field, Function, Symbol, String] pattern
        #
        # @param [Field, Function, Symbol, String] string
        #
        # @return [Function]
        #   The new function.
        #
        def glob(pattern,string)
          Function.new(:GLOB,pattern,string)
        end

        #
        # The `HEX` function.
        #
        # @param [Field, Function, Symbol, Numeric, String] value
        #
        # @return [Function]
        #   The new function.
        #
        def hex(value)
          Function.new(:HEX,value)
        end

        #
        # The `INSERT` function.
        #
        # @param [Field, Function, Symbol, String] string
        #
        # @param [Field, Function, Symbol, Numeric] position
        #
        # @param [Field, Function, Symbol, Numeric] length
        #
        # @param [Field, Function, Symbol, String] new_string
        #
        # @return [Function]
        #   The new function.
        #
        def insert(string,position,length,new_string)
          Function.new(:INSERT,string,position,length,new_string)
        end

        #
        # The `INSTR` function.
        #
        # @param [Field, Function, Symbol, String] string
        #
        # @param [Field, Function, Symbol, String] sub_string
        #
        # @return [Function]
        #   The new function.
        #
        def instr(string,sub_string)
          Function.new(:INSTR,string,sub_string)
        end

        #
        # The `LCASE` function.
        #
        # @param [Field, Function, Symbol, String] string
        #
        # @return [Function]
        #   The new function.
        #
        def lcase(string)
          Function.new(:LCASE,string)
        end

        #
        # The `LEFT` function.
        #
        # @param [Field, Function, Symbol, String] string
        #
        # @param [Field, Function, Symbol, Numeric] length
        #
        # @return [Function]
        #   The new function.
        #
        def left(string,length)
          Function.new(:LEFT,string,length)
        end

        #
        # The `LENGTH` function.
        #
        # @param [Field, Function, Symbol, String] string
        #
        # @return [Function]
        #   The new function.
        #
        def length(string)
          Function.new(:LENGTH,string)
        end

        #
        # The `LIKE` function.
        #
        # @return [Function]
        #   The new function.
        #
        def like(x,y,options=nil)
          if options then Function.new(:LIKE,x,y,options)
          else            Function.new(:LIKE,x,y)
          end
        end

        #
        # The `LOAD_FILE` function.
        #
        # @param [Field, Function, Symbol, String] file_name
        #
        # @return [Function]
        #   The new function.
        #
        def load_file(file_name)
          Function.new(:LOAD_FILE,file_name)
        end

        #
        # The `LOCATE` function.
        #
        # @param [Field, Function, Symbol, String] substring
        #
        # @param [Field, Function, Symbol, String] string
        #
        # @param [Field, Function, Symbol, Numeric, nil] pos
        #
        # @return [Function]
        #   The new function.
        #
        def locate(substring,string,pos=nil)
          if pos then Function.new(:LOCATE,substring,string,pos)
          else        Function.new(:LOCATE,substring,string)
          end
        end

        #
        # The `LOWER` function.
        #
        # @param [Field, Function, Symbol, String] string
        #
        # @return [Function]
        #   The new function.
        #
        def lower(string)
          Function.new(:LOWER,string)
        end

        #
        # The `LPAD` function.
        #
        # @param [Field, Function, Symbol, String] string
        #
        # @param [Field, Function, Symbol, Numeric] length
        #
        # @param [Field, Function, Symbol, String] pad_string
        #
        # @return [Function]
        #   The new function.
        #
        def lpad(string,length,pad_string)
          Function.new(:LPAD,string,length,pad_string)
        end

        #
        # The `LTRIM` function.
        #
        # @param [Field, Function, Symbol, String] string
        #
        # @return [Function]
        #   The new function.
        #
        def ltrim(string)
          Function.new(:LTRIM,string)
        end

        #
        # The `MAKE_SET` function.
        #
        # @param [Field, Function, Symbol, Numeric] bits
        #
        # @param [Array<Field, Function, Symbol, String>] strings
        #
        # @return [Function]
        #   The new function.
        #
        def make_set(bits,*strings)
          Function.new(:MAKE_SET,bits,*strings)
        end

        #
        # The `MID` function.
        #
        # @param [Field, Function, Symbol, String] string
        #
        # @param [Field, Function, Symbol, Numeric] position
        #
        # @param [Field, Function, Symbol, Numeric] length
        #
        # @return [Function]
        #   The new function.
        #
        def mid(string,position,length)
          Function.new(:MID,string,position,length)
        end

        #
        # The `OCT` function.
        #
        # @param [Field, Function, Symbol, Numeric] number
        #
        # @return [Function]
        #   The new function.
        #
        def oct(number)
          Function.new(:OCT,number)
        end

        #
        # The `OCTET_LENGTH` function.
        #
        # @param [Field, Function, Symbol, String] string
        #
        # @return [Function]
        #   The new function.
        #
        def octet_length(string)
          Function.new(:OCTET_LENGTH,string)
        end

        #
        # The `ORD` function.
        #
        # @param [Field, Function, Symbol, String] string
        #
        # @return [Function]
        #   The new function.
        #
        def ord(string)
          Function.new(:ORD,string)
        end

        #
        # The `POSITION` function.
        #
        # @param [BinaryExpr] expr
        #
        # @return [Function]
        #   The new function.
        #
        def position(expr)
          Function.new(:POSITION,expr)
        end

        #
        # The `QUOTE` function.
        #
        # @param [Field, Function, Symbol, String] string
        #
        # @return [Function]
        #   The new function.
        #
        def quote(string)
          Function.new(:QUOTE,string)
        end

        #
        # The `REPEAT` function.
        #
        # @param [Field, Function, Symbol, String] string
        #
        # @param [Field, Function, Symbol, Numeric] count
        #
        # @return [Function]
        #   The new function.
        #
        def repeat(string,count)
          Function.new(:REPEAT,string,count)
        end

        #
        # The `REPLACE` function.
        #
        # @param [Field, Function, Symbol, String] string
        #
        # @param [Field, Function, Symbol, String] from_string
        #
        # @param [Field, Function, Symbol, String] to_string
        #
        # @return [Function]
        #   The new function.
        #
        def replace(string,from_string,to_string)
          Function.new(:REPLACE,string,from_string,to_string)
        end

        #
        # The `REVERSE` function.
        #
        # @param [Field, Function, Symbol, String] string
        #   The input String to reverse.
        #
        # @return [Function]
        #   The new function.
        #
        def reverse(string)
          Function.new(:REVERSE,string)
        end

        #
        # The `RIGHT` function.
        #
        # @param [Field, Function, Symbol, String] string
        #   The input String to extract from.
        #
        # @param [Integer] length
        #   The desired number of characters to extract.
        #
        # @return [Function]
        #   The new function.
        #
        def right(string,length)
          Function.new(:RIGHT,string,length)
        end

        #
        # The `RPAD` function.
        #
        # @param [Field, Function, Symbol, String] string
        #   The original String to pad.
        #
        # @param [Integer] length
        #   The desired length of the String.
        #
        # @param [Field, Function, Symbol, String] pad_string
        #   The String to pad with.
        #
        # @return [Function]
        #   The new function.
        #
        def rpad(string,length,pad_string)
          Function.new(:RPAD,string,length,pad_string)
        end

        #
        # The `RTRIM` function.
        #
        # @param [Field, Function, Symbol, String] string
        #   The original String to trim.
        #
        # @return [Function]
        #   The new function.
        #
        def rtrim(string)
          Function.new(:RTRIM,string)
        end

        #
        # The `SOUNDEX` function.
        #
        # @param [Field, Function, Symbol, String] string
        #   The input string.
        #
        # @return [Function]
        #   The new function.
        #
        def soundex(string)
          Function.new(:SOUNDEX,string)
        end

        #
        # The `SPACE` function.
        #
        # @param [Field, Function, Symbol, Numeric] number
        #
        # @return [Function]
        #   The new function.
        #
        def space(number)
          Function.new(:SPACE,number)
        end

        #
        # The `STRCMP` function.
        #
        # @param [Field, Function, Symbol, String] string1
        #
        # @param [Field, Function, Symbol, String] string2
        #
        # @return [Function]
        #   The new function.
        #
        def strcmp(string1,string2)
          Function.new(:STRCMP,string1,string2)
        end

        #
        # The `SUBSTRING` function.
        #
        # @param [Field, Function, Symbol, String] string
        #   The original string.
        #
        # @param [Integer] position
        #   The beginning index of the substring.
        #
        # @param [Integer, nil] length
        #   The desired length of the substring.
        #
        # @return [Function]
        #   The new function.
        #
        def substring(string,position,length=nil)
          if length then Function.new(:SUBSTRING,string,position,length)
          else           Function.new(:SUBSTRING,string,position)
          end
        end

        #
        # The `SUBSTRING_INDEX` function.
        #
        # @param [Field, Function, Symbol, String] string
        #   The string to search within.
        #
        # @param [Field, Function, Symbol, String] deliminator
        #   The deliminator string to search for.
        #
        # @param [Integer] count
        #   The number of times to search for the deliminator.
        #
        # @return [Function]
        #   The new function.
        #
        def substring_index(string,deliminator,count)
          Function.new(:SUBSTRING_INDEX,string,deliminator,count)
        end

        #
        # The `TRIM` function.
        #
        # @param [String, Hash{Symbol => Object}] string_or_options
        #
        # @option string_or_options [Field, Function, Symbol, String] :both
        #
        # @option string_or_options [Field, Function, Symbol, String] :leading
        #
        # @option string_or_options [Field, Function, Symbol, String] :trailing
        #
        # @option string_or_options [Field, Function, Symbol, String] :from
        #
        # @return [Function]
        #   The new function.
        #
        def trim(string_or_options)
          Function.new(:TRIM,string_or_options)
        end

        #
        # The `UCASE` function.
        #
        # @param [Field, Function, Symbol, String] string
        #   The string argument for `UCASE`.
        #
        # @return [Function]
        #   The new function.
        #
        def ucase(string)
          Function.new(:UCASE,string)
        end

        #
        # The `UNHEX` function.
        #
        # @param [Field, Function, Symbol, String] string
        #   The string argument for `UNHEX`.
        #
        # @return [Function]
        #   The new function.
        #
        def unhex(string)
          Function.new(:UNHEX,string)
        end

        #
        # The `UPPER` function.
        #
        # @param [Field, Function, Symbol, String] string
        #   The string argument for `UPPER`.
        #
        # @return [Function]
        #   The new function.
        #
        def upper(string)
          Function.new(:UPPER,string)
        end

        #
        # The `SLEEP` function.
        #
        # @param [Numeric] secs
        #   The number of seconds to sleep for.
        #
        # @return [Function]
        #   The new function.
        #
        # @since 1.2.0
        #
        def sleep(secs)
          Function.new(:SLEEP,secs)
        end
      end
    end
  end
end
