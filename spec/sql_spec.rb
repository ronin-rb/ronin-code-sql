require 'spec_helper'
require 'ronin/sql/version'

describe SQL do
  it "should have a version" do
    SQL.const_defined?('VERSION').should == true
  end
end
