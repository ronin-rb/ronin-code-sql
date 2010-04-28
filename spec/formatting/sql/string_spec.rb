require 'spec_helper'
require 'ronin/formatting/extensions/sql/string'

describe String do
  before(:all) do
    @string = '/etc/passwd'
    @sql_encoded = '0x2f6574632f706173737764'
    @string_with_quotes = %{"O'Brian"}
  end

  it "should provide the #sql_escape method" do
    @string.should respond_to(:sql_escape)
  end

  it "should provide the #sql_encode method" do
    @string.should respond_to(:sql_encode)
  end

  it "should provide the #sql_decode method" do
    @string.should respond_to(:sql_decode)
  end

  describe "SQL escaping" do
    it "should be able to single-quote escape" do
      @string_with_quotes.sql_escape(:single).should == %{'"O''Brian"'}
    end

    it "should be able to double-quote escape" do
      @string_with_quotes.sql_escape(:double).should == %{"""O'Brian"""}
    end
  end

  describe "SQL-hex encoding" do
    it "should be able to be SQL-hex encoded" do
      @string.sql_encode.should == @sql_encoded
    end

    it "should return an empty String if empty" do
      ''.sql_encode.should == ''
    end
  end

  describe "SQL-hex decoding" do
    it "should be able to be SQL-hex decoded" do
      encoded = @string.sql_encode

      encoded.should == @sql_encoded
      encoded.sql_decode.should == @string
    end

    it "should be able to decode SQL comma-escaping" do
      "'Conan O''Brian'".sql_decode.should == "Conan O'Brian"
    end
  end
end
