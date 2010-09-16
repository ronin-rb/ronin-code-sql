require 'spec_helper'
require 'ronin/sql/injection'

describe SQL::Injection do
  describe "scan" do
    subject { SQL::Injection }

    let(:url) { URI('http://testasp.acunetix.com/showthread.asp?id=2') }

    it "should find all SQL injections" do
      injections = subject.scan(url).to_a

      injections.length.should == 1
      injections[0].param.should == 'id'
      injections[0].sql_options[:escape].should == '2'
    end

    it "should return an Enumerator if no block is given" do
      subject.scan(url).should respond_to(:each)
    end
  end
end
