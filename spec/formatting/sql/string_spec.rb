require 'spec_helper'
require 'ronin/formatting/extensions/sql/string'

describe String do
  it "should provide the #sql_escape method" do
    subject.should respond_to(:sql_escape)
  end

  it "should provide the #sql_encode method" do
    subject.should respond_to(:sql_encode)
  end

  it "should provide the #sql_decode method" do
    subject.should respond_to(:sql_decode)
  end

  describe "#sql_escape" do
    subject { "hello" }

    context "with :single" do
      it "should wrap the String in single-quotes" do
        subject.sql_escape(:single).should == "'hello'"
      end

      context "when the String already contains single-quotes" do
        subject { "O'Brian" }

        it "should escape existing single-quotes" do
          subject.sql_escape(:single).should == "'O''Brian'"
        end
      end
    end

    context "with :double" do
      it "should wrap the String in double-quotes" do
        subject.sql_escape(:double).should == '"hello"'
      end

      context "when the String already contains double-quotes" do
        subject { 'the "thing"' }

        it "should escape existing double-quotes" do
          subject.sql_escape(:double).should == '"the ""thing"""'
        end
      end
    end

    context "with :tick" do
      it "should wrap the String in tick-mark quotes" do
        subject.sql_escape(:tick).should == "`hello`"
      end

      context "when the String already contains tick-marks" do
        subject { "the `thing`" }

        it "should escape existing tick-mark quotes" do
          subject.sql_escape(:tick).should == '`the ``thing```'
        end
      end
    end

    context "with no arguments" do
      it "should default quote to :single" do
        subject.sql_escape.should == subject.sql_escape(:single)
      end
    end

    context "otherwise" do
      it "should raise an ArgumentError" do
        lambda { subject.sql_escape(:foo) }.should raise_error(ArgumentError)
      end
    end
  end

  describe "#sql_unescape" do
    context "when the String is single-quoted" do
      subject { "'hello'" }

      it "should remove leading and tailing single-quotes" do
        subject.sql_unescape.should == "hello"
      end

      context "when the String contains escaped single-quotes" do
        subject { "'O''Brian'" }

        it "should unescape the single-quotes" do
          subject.sql_unescape.should == "O'Brian"
        end
      end
    end

    context "when the String is double-quoted" do
      subject { '"hello"' }

      it "should remove leading and tailing double-quotes" do
        subject.sql_unescape.should == 'hello'
      end

      context "when the String contains escaped double-quotes" do
        subject { '"the ""thing"""' }

        it "should unescape the double-quotes" do
          subject.sql_unescape.should == 'the "thing"'
        end
      end
    end

    context "when the String is tick-mark quoted" do
      subject { '`hello`' }

      it "should remove leading and tailing tick-mark quotes" do
        subject.sql_unescape.should == 'hello'
      end

      context "when the String contains escaped tick-mark quotes" do
        subject { '`the ``thing```' }

        it "should unescape the tick-mark quotes" do
          subject.sql_unescape.should == 'the `thing`'
        end
      end
    end

    context "when the String is not quoted" do
      subject { "hello" }

      it "should raise an exception" do
        lambda { subject.sql_unescape }.should raise_error(TypeError)
      end
    end
  end

  describe "#sql_encode" do
    subject { "/etc/passwd" }

    let(:encoded_string) { '0x2f6574632f706173737764' }

    it "should be able to be SQL-hex encoded" do
      subject.sql_encode.should == encoded_string
    end

    it "should return an empty String if empty" do
      ''.sql_encode.should == ''
    end
  end

  describe "#sql_decode" do
    subject { '2f6574632f706173737764' }

    let(:decoded_string) { '/etc/passwd' }

    it "should be able to be SQL-hex decoded" do
      subject.sql_decode.should == decoded_string
    end

    context "with upper-case hexadecimal" do
      subject { '2F6574632F706173737764' }

      it "should be able to be SQL-hex decoded" do
        subject.sql_decode.should == decoded_string
      end
    end

    context "when the String is a SQL escaped string" do
      subject { "'Conan O''Brian'" }

      it "should unescape the SQL String" do
        subject.sql_decode.should == "Conan O'Brian"
      end
    end
  end
end
