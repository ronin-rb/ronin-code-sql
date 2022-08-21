require 'spec_helper'
require 'ronin/support/encoding/sql'

describe Ronin::Support::Encoding::SQL do
  describe ".escape" do
    let(:data) { "hello" }

    context "when given quotes: :single" do
      it "should wrap the String in single-quotes" do
        expect(subject.escape(data, quotes: :single)).to eq("'hello'")
      end

      context "when the String already contains single-quotes" do
        let(:data) { "O'Brian" }

        it "should escape existing single-quotes" do
          expect(subject.escape(data, quotes: :single)).to eq("'O''Brian'")
        end
      end
    end

    context "when given quotes: :double" do
      it "should wrap the String in double-quotes" do
        expect(subject.escape(data, quotes: :double)).to eq('"hello"')
      end

      context "when the String already contains double-quotes" do
        let(:data) { 'the "thing"' }

        it "should escape existing double-quotes" do
          expect(subject.escape(data, quotes: :double)).to eq('"the ""thing"""')
        end
      end
    end

    context "when given quotes: :tick" do
      it "should wrap the String in tick-mark quotes" do
        expect(subject.escape(data, quotes: :tick)).to eq("`hello`")
      end

      context "when the String already contains tick-marks" do
        let(:data) { "the `thing`" }

        it "should escape existing tick-mark quotes" do
          expect(subject.escape(data, quotes: :tick)).to eq('`the ``thing```')
        end
      end
    end

    context "with no quotes: keyword argument" do
      it "should default single quotes" do
        expect(subject.escape(data)).to eq(
          subject.escape(data, quotes: :single)
        )
      end
    end

    context "when given an unknown quotes: keyword argument" do
      let(:quotes) { :foo }

      it "should raise an ArgumentError" do
        expect {
          subject.escape(data, quotes: quotes)
        }.to raise_error(ArgumentError,"invalid quoting style #{quotes.inspect}")
      end
    end
  end

  describe ".unescape" do
    context "when the String is single-quoted" do
      let(:data) { "'hello'" }

      it "should remove leading and tailing single-quotes" do
        expect(subject.unescape(data)).to eq("hello")
      end

      context "when the String contains escaped single-quotes" do
        let(:data) { "'O''Brian'" }

        it "should unescape the single-quotes" do
          expect(subject.unescape(data)).to eq("O'Brian")
        end
      end
    end

    context "when the String is double-quoted" do
      let(:data) { '"hello"' }

      it "should remove leading and tailing double-quotes" do
        expect(subject.unescape(data)).to eq('hello')
      end

      context "when the String contains escaped double-quotes" do
        let(:data) { '"the ""thing"""' }

        it "should unescape the double-quotes" do
          expect(subject.unescape(data)).to eq('the "thing"')
        end
      end
    end

    context "when the String is tick-mark quoted" do
      let(:data) { '`hello`' }

      it "should remove leading and tailing tick-mark quotes" do
        expect(subject.unescape(data)).to eq('hello')
      end

      context "when the String contains escaped tick-mark quotes" do
        let(:data) { '`the ``thing```' }

        it "should unescape the tick-mark quotes" do
          expect(subject.unescape(data)).to eq('the `thing`')
        end
      end
    end

    context "when the String is not quoted" do
      let(:data) { "hello" }

      it "should raise an exception" do
        expect {
          subject.unescape(data)
        }.to raise_error(ArgumentError,"#{data.inspect} is not properly quoted")
      end
    end
  end

  describe ".encode" do
    let(:data) { "/etc/passwd" }

    let(:encoded_string) { '0x2f6574632f706173737764' }

    it "should be able to be SQL-hex encoded" do
      expect(subject.encode(data)).to eq(encoded_string)
    end

    it "should return an empty String if empty" do
      expect(subject.encode('')).to eq('')
    end
  end

  describe ".decode" do
    let(:data)           { '2f6574632f706173737764' }
    let(:decoded_string) { '/etc/passwd'            }

    it "should be able to be SQL-hex decoded" do
      expect(subject.decode(data)).to eq(decoded_string)
    end

    context "with upper-case hexadecimal" do
      let(:data) { '2F6574632F706173737764' }

      it "should be able to be SQL-hex decoded" do
        expect(subject.decode(data)).to eq(decoded_string)
      end
    end

    context "when the String is a SQL escaped string" do
      let(:data) { "'Conan O''Brian'" }

      it "should unescape the SQL String" do
        expect(subject.decode(data)).to eq("Conan O'Brian")
      end
    end
  end
end
