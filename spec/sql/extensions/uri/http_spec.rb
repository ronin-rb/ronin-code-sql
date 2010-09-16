require 'spec_helper'
require 'ronin/sql/extensions/uri/http'

describe URI::HTTP do
  let(:url) { URI('http://testasp.acunetix.com/showthread.asp?id=2') }

  it "should determine which query params have SQL errors" do
    url.sql_errors.should == {'id' => '2'}
  end

  it "should scan the URL for all SQL injections" do
    injections = url.sqli_scan.to_a

    injections.length.should == 1
    injections[0].param.should == 'id'
    injections[0].sql_options[:escape].should == '2'
  end

  it "should find the first working SQL injection" do
    injection = url.first_sqli

    injection.param.should == 'id'
    injection.sql_options[:escape].should == '2'
  end

  it "should determine if a URL is vulnerable to SQL injection" do
    url.has_sqli?.should == true
  end
end
