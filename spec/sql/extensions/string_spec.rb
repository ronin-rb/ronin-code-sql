require 'ronin/sql/extensions/string'

require 'spec_helper'

describe String do
  describe "SQL-hex encoding" do
    it "should be able to be SQL-hex encoded" do
      '/etc/passwd'.sql_encode.should == '0x2f6574632f706173737764'
    end

    it "should return an empty String if empty" do
      ''.sql_encode.should == ''
    end
  end

  describe "SQL-hex decoding" do
    it "should be able to be SQL-hex decoded" do
      encoded = '/etc/passwd'.sql_encode

      encoded.should == '0x2f6574632f706173737764'
      encoded.sql_decode.should == '/etc/passwd'
    end

    it "should be able to decode SQL comma-escaping" do
      "'Conan O''Brian'".sql_decode.should == "Conan O'Brian"
    end
  end
end
