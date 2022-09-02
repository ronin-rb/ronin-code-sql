require 'spec_helper'
require 'sql/function_examples'
require 'ronin/code/sql/functions'
require 'ronin/code/sql/binary_expr'

describe Ronin::Code::SQL::Functions do
  subject { Object.new.extend(described_class) }

  describe "#count" do
    it "should create a COUNT function" do
      expect(subject.count.name).to eq(:COUNT)
    end

    context "without arguments" do
      it "should default arguments to *" do
        expect(subject.count.arguments).to eq([:*])
      end
    end
  end

  include_examples "Function", :max, [:column]
  include_examples "Function", :min, [:column]
  include_examples "Function", :avg, [:column]
  include_examples "Function", :sum, [:column]
  include_examples "Function", :sqrt, [1]
  include_examples "Function", :rand, [1]
  include_examples "Function", :abs,  [-1]
  include_examples "Function", :acos, [30]
  include_examples "Function", :asin, [30]
  include_examples "Function", :atan, [30]
  include_examples "Function", :atan2, [30,60]
  include_examples "Function", :bit_and, [0xff]
  include_examples "Function", :bit_count, [0xff]
  include_examples "Function", :bit_or, [0xff]
  include_examples "Function", :ceil, [0.5]
  include_examples "Function", :ceiling, [0.5]
  include_examples "Function", :cos, [0.5]
  include_examples "Function", :cot, [0.5]
  include_examples "Function", :degrees, [0.5]
  include_examples "Function", :exp, [0.5]
  include_examples "Function", :floor, [0.5]
  include_examples "Function", :format, [:date, 'YYYY-MM-DD']
  include_examples "Function", :greatest, [1,2,3,4]
  include_examples "Function", :interval, [1,2,3,4]
  include_examples "Function", :least, [1,2,3,4]
  include_examples "Function", :log, [2], [10,2]
  include_examples "Function", :log10, [2]
  include_examples "Function", :mod, [2,10]
  include_examples "Function", :pi
  include_examples "Function", :pow, [2,10]
  include_examples "Function", :power, [2,10]
  include_examples "Function", :radians, [30]
  include_examples "Function", :random
  include_examples "Function", :round, [15.79], [15.79, 1]
  include_examples "Function", :sign, [10]
  include_examples "Function", :sin, [30]
  include_examples "Function", :sqrt, [100]
  include_examples "Function", :std, [:column]
  include_examples "Function", :stddev, [:column]
  include_examples "Function", :tan, [30]
  include_examples "Function", :truncate, [:price,2]
  include_examples "Function", :ascii, ["hello"]
  include_examples "Function", :bin, [12]
  include_examples "Function", :bit_length, ["hello"]
  include_examples "Function", :char, [104, 101, 108, 108, 111]
  include_examples "Function", :char_length, ["hello"]
  include_examples "Function", :character_length, ["hello"]
  include_examples "Function", :concat, ["he", "ll", "o"]
  include_examples "Function", :concat_ws, ["he", "ll", "o"]
  include_examples "Function", :conv, ["ff", 16, 10]
  include_examples "Function", :elt, ["ff", 16, 10]
  include_examples "Function", :export_set, [5, 'Y', 'N']
  include_examples "Function", :field, ["hello", "lo"]
  include_examples "Function", :find_in_set, ['b', 'a,b,c,d']
  include_examples "Function", :glob, [:name, '*foo*']
  include_examples "Function", :hex, ["hello"]
  include_examples "Function", :insert, ["hello",1,2,"foo"]
  include_examples "Function", :instr, ["hello","lo"]
  include_examples "Function", :lcase, ["HELLO"]
  include_examples "Function", :left, ["hello", 10]
  include_examples "Function", :length, ["hello"]
  include_examples "Function", :like, [:name, '%foo%']
  include_examples "Function", :load_file, ["path"]
  include_examples "Function", :locate, ["o", "hello"]
  include_examples "Function", :lower, ["HELLO"]
  include_examples "Function", :lpad, ["hello", 10, ' ']
  include_examples "Function", :ltrim, ["     hello"]
  include_examples "Function", :make_set, [8|1, 'a', 'b', 'c', 'd']
  include_examples "Function", :mid, ["hello",2,3]
  include_examples "Function", :oct, ["55"]
  include_examples "Function", :octet_length, ["55"]
  include_examples "Function", :ord, ["55"]
  include_examples "Function", :position, [
    Ronin::Code::SQL::BinaryExpr.new('55',:IN,:name)
  ]
  include_examples "Function", :quote, ["hello"]
  include_examples "Function", :repeat, ["A", 100]
  include_examples "Function", :replace, ["foox", "foo", "bar"]
  include_examples "Function", :reverse, ["hello"]
  include_examples "Function", :right, ["hello", 10]
  include_examples "Function", :rpad, ["hello", 10, ' ']
  include_examples "Function", :rtrim, ["hello     "]
  include_examples "Function", :soundex, ["smythe"]
  include_examples "Function", :space, [10]
  include_examples "Function", :strcmp, ['foo', 'foox']
  include_examples "Function", :substring, ['hello', 2, 1]
  include_examples "Function", :substring_index, ['foo-bar', '-', 1]
  include_examples "Function", :trim, ['   foo    ']
  include_examples "Function", :ucase, ['foo']
  include_examples "Function", :unhex, ['4D7953514C']
  include_examples "Function", :upper, ['hello']
  include_examples "Function", :sleep, [5]
end
