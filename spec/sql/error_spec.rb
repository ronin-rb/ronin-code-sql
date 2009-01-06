require 'ronin/sql/error'

require 'spec_helper'

describe SQL::Error do
  it "should provide error patterns" do
    SQL::Error.patterns.should_not be_empty
  end

  it "should return patterns for specified database types" do
    patterns = SQL::Error.patterns_for(:mysql, :php)

    patterns[0].should == SQL::Error.patterns[:mysql]
    patterns[1].should == SQL::Error.patterns[:php]
  end

  it "should return patterns for a specified SQL dialect" do
    patterns = SQL::Error.patterns_for_dialect(:common)

    patterns.each do |pattern|
      pattern.dialect.should == :common
    end
  end
end
