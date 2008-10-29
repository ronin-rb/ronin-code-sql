require 'ronin/sql/version'

require 'spec_helper'

describe SQL do
  it "should have a version" do
    SQL.const_defined?('VERSION').should == true
  end
end
