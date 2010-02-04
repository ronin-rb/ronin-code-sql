require 'ronin/sql/extensions/uri/http'

require 'spec_helper'

describe URI::HTTP do
  before(:all) do
    @url = URI('http://testasp.acunetix.com/showthread.asp?id=2')
  end

  it "should determine which query params have SQL errors" do
    pending "Spring Cleaning" do
      raise()

      @url.sql_errors.should == {'id' => '2'}
    end
  end

  it "should find all SQL injections" do
    pending "Spring Cleaning" do
      raise()

      injections = @url.sql_injections
      injection = injections.first

      injections.length.should == 1

      injection.param.should == 'id'
      injection.sql_options[:escape].should == '2'
    end
  end

  it "should find the first working SQL injection" do
    pending "Spring Cleaning" do
      raise()

      injection = @url.sql_injection

      injection.param.should == 'id'
      injection.sql_options[:escape].should == '2'
    end
  end

  it "should determine if a URL is vulnerable to SQL injection" do
    pending "Spring Cleaning" do
      raise()

      @url.has_sql_injections?.should == true
    end
  end
end
