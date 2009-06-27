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

  it "should determine which query params have SQL injection" do
    inj = @url.sql_injection

    inj.param.should == 'id'
    inj.sql_options[:escape].should == '2'
  end
end
