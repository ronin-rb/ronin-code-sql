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

require 'ronin/sql/function'

module Ronin
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
      # @param [Field, Symbol] field
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
      # @return [Function]
      #   The new function.
      #
      def abs(x)
        Function.new(:ABS,x)
      end

      #
      # The `ACOS` function.
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
      # @return [Function]
      #   The new function.
      #
      def asin(x)
        Function.new(:ASIN,x)
      end

      #
      # The `ATAN` function.
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
      # @return [Function]
      #   The new function.
      #
      def atan2(y,x)
        Function.new(:ATAN2,y,x)
      end

      #
      # The `BIT_AND` function.
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
      # @return [Function]
      #   The new function.
      #
      def bit_count(x)
        Function.new(:BIT_COUNT,x)
      end

      #
      # The `BIT_OR` function.
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
      # @return [Function]
      #   The new function.
      #
      def ceil(x)
        Function.new(:CEIL,x)
      end

      #
      # The `CEILING` function.
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
      # @return [Function]
      #   The new function.
      #
      def cos(x)
        Function.new(:COS,x)
      end

      #
      # The `COT` function.
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
      # @return [Function]
      #   The new function.
      #
      def degrees(x)
        Function.new(:DEGREES,x)
      end

      #
      # The `EXP` function.
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
      # @return [Function]
      #   The new function.
      #
      def floor(x)
        Function.new(:FLOOR,x)
      end

      #
      # The `FORMAT` function.
      #
      # @return [Function]
      #   The new function.
      #
      def format(x,d)
        Function.new(:FORMAT,x,d)
      end

      #
      # The `GREATEST` function.
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
      # @return [Function]
      #   The new function.
      #
      def interval(*values)
        Function.new(:INTERVAL,*values)
      end

      #
      # The `LEAST` function.
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
      # @return [Function]
      #   The new function.
      #
      def log(*b,x)
        Function.new(:LOG,*b,x)
      end

      #
      # The `LOG10` function.
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
      # @return [Function]
      #   The new function.
      #
      def pow(x,y)
        Function.new(:POW,x,y)
      end

      #
      # The `POWER` function.
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
      # @return [Function]
      #   The new function.
      #
      def sign(x)
        Function.new(:SIGN,x)
      end

      #
      # The `SIN` function.
      #
      # @return [Function]
      #   The new function.
      #
      def sin(x)
        Function.new(:SIN,x)
      end

      #
      # The `SQRT` function.
      #
      # @return [Function]
      #   The new function.
      #
      def sqrt(x)
        Function.new(:SQRT,x)
      end

      #
      # The `STD` function.
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
      # @return [Function]
      #   The new function.
      #
      def stddev(field)
        Function.new(:STDDEV,field)
      end

      #
      # The `TAN` function.
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
      # @return [Function]
      #   The new function.
      #
      def ascii(string)
        Function.new(:ASCII,string)
      end

      #
      # The `BIN` function.
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
      # @return [Function]
      #   The new function.
      #
      def bit_length(string)
        Function.new(:BIT_LENGTH,string)
      end

      #
      # The `CHAR` function.
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
      # @return [Function]
      #   The new function.
      #
      def char_length(string)
        Function.new(:CHAR_LENGTH,string)
      end

      #
      # The `CHARACTER_LENGTH` function.
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
      # @return [Function]
      #   The new function.
      #
      def concat(*strings)
        Function.new(:CONCAT,*strings)
      end

      #
      # The `CONCAT_WS` function.
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
      # @return [Function]
      #   The new function.
      #
      def conv(n,from_base,to_base)
        Function.new(:CONV,n,from_base,to_base)
      end

      #
      # The `ELT` function.
      #
      # @return [Function]
      #   The new function.
      #
      def elt(n,*strings)
        Function.new(:ELT,n,*strings)
      end

      #
      # The `EXPORT_SET` function.
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
      # @return [Function]
      #   The new function.
      #
      def field(*strings)
        Function.new(:FIELD,*strings)
      end

      #
      # The `FIND_IN_SET` function.
      #
      # @return [Function]
      #   The new function.
      #
      def find_in_set(string,*set)
        Function.new(:FIND_IN_SET,string,*set)
      end

      #
      # The `GLOB` function.
      #
      # @return [Function]
      #   The new function.
      #
      def glob(x,y)
        Function.new(:GLOB,x,y)
      end

      #
      # The `HEX` function.
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
      # @return [Function]
      #   The new function.
      #
      def insert(string,position,length,new_string)
        Function.new(:INSERT,string,position,length,new_string)
      end

      #
      # The `INSTR` function.
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
      # @return [Function]
      #   The new function.
      #
      def lcase(string)
        Function.new(:LCASE,string)
      end

      #
      # The `LEFT` function.
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
      # @return [Function]
      #   The new function.
      #
      def load_file(file_name)
        Function.new(:LOAD_FILE,file_name)
      end

      #
      # The `LOCATE` function.
      #
      # @return [Function]
      #   The new function.
      #
      def locate(sub_string,string,pos=nil)
        if pos then Function.new(:LOCATE,sub_string,string,pos)
        else        Function.new(:LOCATE,sub_string,string)
        end
      end

      #
      # The `LOWER` function.
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
      # @return [Function]
      #   The new function.
      #
      def lpad(string,length,pad_string)
        Function.new(:LPAD,string,length,pad_string)
      end

      #
      # The `LTRIM` function.
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
      # @return [Function]
      #   The new function.
      #
      def make_set(bits,*strings)
        Function.new(:MAKE_SET,bits,*strings)
      end

      #
      # The `MID` function.
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
      # @return [Function]
      #   The new function.
      #
      def oct(n)
        Function.new(:OCT,n)
      end

      #
      # The `OCTET_LENGTH` function.
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
      # @return [Function]
      #   The new function.
      #
      def ord(string)
        Function.new(:ORD,string)
      end

      #
      # The `POSITION` function.
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
      # @return [Function]
      #   The new function.
      #
      def quote(string)
        Function.new(:QUOTE,string)
      end

      #
      # The `REPEAT` function.
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
      # @return [Function]
      #   The new function.
      #
      def replace(string,from_string,to_string)
        Function.new(:REPLACE,string,from_string,to_string)
      end
      
      #
      # The `REVERSE` function.
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
      # @return [Function]
      #   The new function.
      #
      def right(string,length)
        Function.new(:RIGHT,string,length)
      end

      #
      # The `RPAD` function.
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
      # @return [Function]
      #   The new function.
      #
      def rtrim(string)
        Function.new(:RTRIM,string)
      end

      #
      # The `SOUNDEX` function.
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
      # @return [Function]
      #   The new function.
      #
      def space(n)
        Function.new(:SPACE,n)
      end

      #
      # The `STRCMP` function.
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
      # @return [Function]
      #   The new function.
      #
      def substring_index(string,deliminator,count)
        Function.new(:SUBSTRING_INDEX,string,deliminator,count)
      end

      #
      # The `TRIM` function.
      #
      # @param [String, Hash] string_or_options
      #
      # @option string_or_options [String] :both
      #
      # @option string_or_options [String] :leading
      #
      # @option string_or_options [String] :trailing
      #
      # @option string_or_options [String] :from
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
      # @return [Function]
      #   The new function.
      #
      def ucase(string)
        Function.new(:UCASE,string)
      end

      #
      # The `UNHEX` function.
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
      # @return [Function]
      #   The new function.
      #
      def upper(string)
        Function.new(:UPPER,string)
      end
    end
  end
end
