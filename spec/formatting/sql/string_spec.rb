require 'spec_helper'
require 'ronin/formatting/extensions/sql/string'

describe String do
  subject { "O'Briand" }

  let(:single_quoted_string) { %{"O'Brian"} }
  let(:double_quoted_string) { %{'O''Brian'} }
  let(:tick_mark_quoted_string) { %{`O'Brian`} }

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
    context "with :single" do
      subject { "hello" }

      it "should wrap the String in single-quotes" do
        subject.sql_escape(:single).should == "'hello'"
      end

      context "when the String already contains single-quotes" do
        subject { "O'Brian" }

        it "should escape existing single-quotes" do
          subject.sql_escape(:single).should == "O''Brian"
        end
      end
    end

    context "with :double" do
      subject { "hello" }

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
      subject { "hello" }

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
    subject { '0x2f6574632f706173737764' }

    let(:decoded_string) { '/etc/passwd' }

    it "should be able to be SQL-hex decoded" do
      subject.sql_decode.should == decoded_string
    end

    context "when the String is a SQL string" do
      subject { "'Conan O''Brian'" }

      let(:decoded_string) { "Conan O'Brian" }

      it "should unescape the SQL String" do
        subject.sql_decode.should == decoded_string
      end
    end
  end
end
