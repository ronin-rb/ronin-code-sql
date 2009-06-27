require 'ronin/sql/extensions/uri/http'

require 'spec_helper'

describe URI::HTTP do
  before(:all) do
    @url = URI('http://testasp.acunetix.com/showthread.asp?id=2')
  end

  it "should include URI::QueryParams" do
    @url.class.include?(URI::QueryParams)
  end

  it "should determine which query params have SQL errors" do
    @url.sql_errors.should == {'id' => '2'}
  end

  it "should find all SQL injections" do
    injections = @url.sql_injections
    injection = injections.first

    injections.length.should == 1

    injection.param.should == 'id'
    injection.sql_options[:escape].should == '2'
  end

  it "should find the first working SQL injection" do
    injection = @url.sql_injection

    injection.param.should == 'id'
    injection.sql_options[:escape].should == '2'
  end

  it "should determine if a URL is vulnerable to SQL injection" do
    @url.has_sql_injections?.should == true
  end
end
