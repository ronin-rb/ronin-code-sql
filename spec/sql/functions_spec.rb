require 'spec_helper'
require 'ronin/sql/functions'

describe SQL::Functions do
  subject { Object.new.extend(described_class) }

  describe "#count" do
    it "should create a COUNT function" do
      subject.count.name.should == :COUNT
    end

    context "without arguments" do
      it "should default arguments to *" do
        subject.count.arguments.should == [:*]
      end
    end
  end

  describe "#max" do
    it "should create a MAX function" do
      subject.max(:column).name.should == :MAX
    end
  end

  describe "#min" do
    it "should create a MIN function" do
      subject.min(:column).name.should == :MIN
    end
  end

  describe "#avg" do
    it "should create a AVG function" do
      subject.avg(:column).name.should == :AVG
    end
  end

  describe "#sum" do
    it "should create a SUM function" do
      subject.sum(:column).name.should == :SUM
    end
  end

  describe "#sqrt" do
    it "should create a SQRT function" do
      subject.sqrt(1).name.should == :SQRT
    end
  end

  describe "#rand" do
    it "should create a RAND function" do
      subject.rand(1).name.should == :RAND
    end
  end

  describe "#abs" do
    it "should create a ABS function" do
      subject.abs(-1).name.should == :ABS
    end
  end

  describe "#acos" do
    it "should create a ACOS function" do
      subject.acos(1).name.should == :ACOS
    end
  end

  describe "#asin" do
    it "should create a ASIN function" do
      subject.asin(1).name.should == :ASIN
    end
  end

  describe "#atan" do
    it "should create a ATAN function" do
      subject.atan(1).name.should == :ATAN
    end
  end

  describe "#atan2" do
    it "should create a ATAN2 function" do
      subject.atan2(1,2).name.should == :ATAN2
    end
  end

  describe "#bit_and" do
    it "should create a BIT_AND function" do
      subject.bit_and(0xff).name.should == :BIT_AND
    end
  end

  describe "#bit_count" do
    it "should create a BIT_COUNT function" do
      subject.bit_count(0xff).name.should == :BIT_COUNT
    end
  end

  describe "#bit_or" do
    it "should create a BIT_OR function" do
      subject.bit_or(0xff).name.should == :BIT_OR
    end
  end

  describe "#ceil" do
    it "should create a CEIL function" do
      subject.ceil(0.5).name.should == :CEIL
    end
  end

  describe "#ceiling" do
    it "should create a CEILING function" do
      subject.ceiling(0.5).name.should == :CEILING
    end
  end

  describe "#cos" do
    it "should create a COS function" do
      subject.cos(0.5).name.should == :COS
    end
  end

  describe "#cot" do
    it "should create a COT function" do
      subject.cot(0.5).name.should == :COT
    end
  end

  describe "#degrees" do
    it "should create a DEGREES function" do
      subject.degrees(0.5).name.should == :DEGREES
    end
  end

  describe "#exp" do
    it "should create a EXP function" do
      subject.exp(0.5).name.should == :EXP
    end
  end

  describe "#floor" do
    it "should create a FLOOR function" do
      subject.floor(0.5).name.should == :FLOOR
    end
  end

  describe "#format" do
    it "should create a FORMAT function" do
      subject.format(:date,'YYYY-MM-DD').name.should == :FORMAT
    end
  end

  describe "#greatest" do
    it "should create a GREATEST function" do
      subject.greatest(1,2,3,4).name.should == :GREATEST
    end
  end

  describe "#interval" do
    it "should create a INTERVAL function" do
      subject.interval(1,2,3,4).name.should == :INTERVAL
    end
  end

  describe "#least" do
    it "should create a LEAST function" do
      subject.least(1,2,3,4).name.should == :LEAST
    end
  end

  describe "#log" do
    it "should create a LOG function" do
      subject.log(2).name.should == :LOG
    end

    context "when given two arguments" do
      it "should accept a leading base argument" do
        subject.log(10,2).arguments.should == [10, 2]
      end
    end
  end

  describe "#log10" do
    it "should create a LOG10 function" do
      subject.log10(2).name.should == :LOG10
    end
  end

  describe "#mod" do
    it "should create a MOD function" do
      subject.mod(2,10).name.should == :MOD
    end
  end

  describe "#pi" do
    it "should create a PI function" do
      subject.pi.name.should == :PI
    end
  end

  describe "#pow" do
    it "should create a POW function" do
      subject.pow(2,10).name.should == :POW
    end
  end

  describe "#power" do
    it "should create a POWER function" do
      subject.power(2,10).name.should == :POWER
    end
  end

  describe "#radians" do
    it "should create a RADIANS function" do
      subject.radians(30).name.should == :RADIANS
    end
  end

  describe "#random" do
    it "should create a RANDOM function" do
      subject.random.name.should == :RANDOM
    end
  end

  describe "#round" do
    it "should create a ROUND function" do
      subject.round(15.79).name.should == :ROUND
    end

    context "when an additional argument is given" do
      it "should accept a decimals argument" do
        subject.round(15.79,1).name.should == :ROUND
      end
    end
  end

  describe "#sign" do
    it "should create a SIGN function" do
      subject.sign(10).name.should == :SIGN
    end
  end

  describe "#sin" do
    it "should create a SIN function" do
      subject.sin(30).name.should == :SIN
    end
  end

  describe "#sqrt" do
    it "should create a SQRT function" do
      subject.sqrt(100).name.should == :SQRT
    end
  end

  describe "#std" do
    it "should create a STD function" do
      subject.std(:price).name.should == :STD
    end
  end

  describe "#stddev" do
    it "should create a STD function" do
      subject.stddev(:price).name.should == :STDDEV
    end
  end

  describe "#tan" do
    it "should create a TAN function" do
      subject.tan(30).name.should == :TAN
    end
  end

  describe "#truncate" do
    it "should create a TRUNCATE function" do
      subject.truncate(:price,2).name.should == :TRUNCATE
    end
  end

  describe "#ascii" do
    it "should create a ASCII function" do
      subject.ascii("hello").name.should == :ASCII
    end
  end

  describe "#bin" do
    it "should create a BIN function" do
      subject.bin(12).name.should == :BIN
    end
  end

  describe "#bit_length" do
    it "should create a BIT_LENGTH function" do
      subject.bit_length("hello").name.should == :BIT_LENGTH
    end
  end

  describe "#char" do
    it "should create a CHAR function" do
      subject.char(104, 101, 108, 108, 111).name.should == :CHAR
    end
  end

  describe "#char_length" do
    it "should create a CHAR_LENGTH function" do
      subject.char_length("hello").name.should == :CHAR_LENGTH
    end
  end

  describe "#character_length" do
    it "should create a CHARACTER_LENGTH function" do
      subject.character_length("hello").name.should == :CHARACTER_LENGTH
    end
  end

  describe "#concat" do
    it "should create a CONCAT function" do
      subject.concat("he","ll","o").name.should == :CONCAT
    end
  end

  describe "#concat_ws" do
    it "should create a CONCAT_WS function" do
      subject.concat_ws("he","ll","o").name.should == :CONCAT_WS
    end
  end

  describe "#conv" do
    it "should create a CONV function" do
      subject.conv('ff',16,10).name.should == :CONV
    end
  end

  describe "#elt" do
    it "should create a ELT function" do
      subject.elt(1,'foo','bar').name.should == :ELT
    end
  end

  describe "#export_set" do
    it "should create a EXPORT_SET function" do
      subject.export_set(5,'Y','N').name.should == :EXPORT_SET
    end
  end

  describe "#field" do
    it "should create a FIELD function" do
      subject.field("hello",'lo').name.should == :FIELD
    end
  end

  describe "#find_in_set" do
    it "should create a FIND_IN_SET function" do
      subject.find_in_set("b",'a,b,c,d').name.should == :FIND_IN_SET
    end
  end

  describe "#glob" do
    it "should create a GLOB function" do
      subject.glob(:name,"*foo*").name.should == :GLOB
    end
  end

  describe "#hex" do
    it "should create a HEX function" do
      subject.hex("hello").name.should == :HEX
    end
  end

  describe "#insert" do
    it "should create a INSTR function" do
      subject.insert("hello",1,2,"foo").name.should == :INSERT
    end
  end

  describe "#instr" do
    it "should create a INSTR function" do
      subject.instr("hello",'lo').name.should == :INSTR
    end
  end

  describe "#lcase" do
    it "should create a LCASE function" do
      subject.lcase("HELLO").name.should == :LCASE
    end
  end

  describe "#left" do
    it "should create a LEFT function" do
      subject.left("hello",10).name.should == :LEFT
    end
  end

  describe "#length" do
    it "should create a LENGTH function" do
      subject.length("hello").name.should == :LENGTH
    end
  end

  describe "#like" do
    it "should create a LIKE function" do
      subject.like(:name,"%foo%").name.should == :LIKE
    end
  end

  describe "#load_file" do
    it "should create a LOAD_FILE function" do
      subject.load_file("path").name.should == :LOAD_FILE
    end
  end

  describe "#locate" do
    it "should create a LOCATE function" do
      subject.locate("o","hello").name.should == :LOCATE
    end
  end

  describe "#lower" do
    it "should create a LOWER function" do
      subject.lower("HELLO").name.should == :LOWER
    end
  end

  describe "#lpad" do
    it "should create a LPAD function" do
      subject.lpad("hello",10,' ').name.should == :LPAD
    end
  end

  describe "#ltrim" do
    it "should create a LTRIM function" do
      subject.ltrim("    hello").name.should == :LTRIM
    end
  end

  describe "#make_set" do
    it "should create a MAKE_SET function" do
      subject.make_set(8|1, 'a', 'b', 'c', 'd').name.should == :MAKE_SET
    end
  end

  describe "#mid" do
    it "should create a MID function" do
      subject.mid("hello",2,3).name.should == :MID
    end
  end

  describe "#oct" do
    it "should create a OCT function" do
      subject.oct('55').name.should == :OCT
    end
  end

  describe "#octet_length" do
    it "should create a OCTET_LENGTH function" do
      subject.octet_length('55').name.should == :OCTET_LENGTH
    end
  end

  describe "#ord" do
    it "should create a ORD function" do
      subject.ord('55').name.should == :ORD
    end
  end

  describe "#position" do
    let(:expr) { SQL::BinaryExpr.new('55',:IN,:name) }

    it "should create a POSITION function" do
      subject.position(expr).name.should == :POSITION
    end
  end

  describe "#quote" do
    it "should create a QUOTE function" do
      subject.quote("hello").name.should == :QUOTE
    end
  end

  describe "#repeat" do
    it "should create a REPEAT function" do
      subject.repeat("A",10).name.should == :REPEAT
    end
  end

  describe "#replace" do
    it "should create a REPLACE function" do
      subject.replace("foox","foo","bar").name.should == :REPLACE
    end
  end

  describe "#reverse" do
    it "should create a REVERSE function" do
      subject.reverse("hello").name.should == :REVERSE
    end
  end

  describe "#right" do
    it "should create a RIGHT function" do
      subject.right("hello",10).name.should == :RIGHT
    end
  end

  describe "#rpad" do
    it "should create a RPAD function" do
      subject.rpad("hello",10,' ').name.should == :RPAD
    end
  end

  describe "#rtrim" do
    it "should create a RTRIM function" do
      subject.rtrim("hello   ").name.should == :RTRIM
    end
  end

  describe "#soundex" do
    it "should create a SOUNDEX function" do
      subject.soundex("smythe").name.should == :SOUNDEX
    end
  end

  describe "#space" do
    it "should create a SPACE function" do
      subject.space(10).name.should == :SPACE
    end
  end

  describe "#strcmp" do
    it "should create a STRCMP function" do
      subject.strcmp("foo","foox").name.should == :STRCMP
    end
  end

  describe "#substring" do
    it "should create a SUBSTRING function" do
      subject.substring("hello",2,1).name.should == :SUBSTRING
    end
  end

  describe "#substring_index" do
    it "should create a SUBSTRING function" do
      subject.substring_index("foo-bar",'-',1).name.should == :SUBSTRING_INDEX
    end
  end

  describe "#trim" do
    it "should create a TRIM function" do
      subject.trim("  foo  ").name.should == :TRIM
    end
  end

  describe "#ucase" do
    it "should create a UCASE function" do
      subject.ucase("foo").name.should == :UCASE
    end
  end

  describe "#unhex" do
    it "should create a UNHEX function" do
      subject.unhex("4D7953514C").name.should == :UNHEX
    end
  end

  describe "#upper" do
    it "should create a UPPER function" do
      subject.upper("hello").name.should == :UPPER
    end
  end
end
