require 'ronin/code/sql/encoder'

require 'spec_helper'
require 'code/sql/classes/test_encoder'

describe Code::SQL::Encoder do
  describe "default" do
    before(:all) do
      @encoder = TestEncoder.new
    end

    it "should encode a keyword" do
      @encoder.test_keyword(:id).should == "id"
    end

    it "should encode a NULL keyword" do
      @encoder.test_null().should == 'null'
    end

    it "should encode a true value" do
      @encoder.test_boolean(true).should == 'true'
    end

    it "should encode a false value" do
      @encoder.test_boolean(false).should == 'false'
    end

    it "should encode an Integer" do
      @encoder.test_integer(10).should == '10'
    end

    it "should encode a Float" do
      @encoder.test_float(0.5).should == '0.5'
    end

    it "should encode a String" do
      @encoder.test_string('hello').should == "\"hello\""
    end

    it "should encode an empty Array" do
      @encoder.test_list().should == "()"
    end

    it "should encode a singleton Array" do
      @encoder.test_list(1).should == "1"
    end

    it "should encode an Array" do
      @encoder.test_list(1,2,3).should == "(1,2,3)"
    end

    it "should encode an empty Hash" do
      @encoder.test_hash({}).should == "()"
    end

    it "should encode a singleton Hash" do
      @encoder.test_hash({:count => 5}).should == "count=5"
    end

    it "should encode a single Hash" do
      update = {:user => 'bob', :password => 'lol'}

      @encoder.test_hash(update).should == "(user=\"bob\",password=\"lol\")"
    end

    it "should encode multiple elements" do
      @encoder.test(1, :eq, 1).should == ['1', '=', '1']
    end
  end
end
