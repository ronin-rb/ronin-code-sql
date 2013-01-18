require 'spec_helper'
require 'ronin/sql/literals'

describe SQL::Literals do
  subject { Object.new.extend(described_class) }

  describe "#null" do
    it "should return a Literal" do
      subject.null.should be_kind_of(SQL::Literal)
    end

    it "should have the value of :NULL" do
      subject.null.value.should == :NULL
    end
  end

  describe "#int" do
    it "should return a Literal" do
      subject.int(5).should be_kind_of(SQL::Literal)
    end

    it "should convert the value to an Integer" do
      subject.int('5').value.should == 5
    end
  end

  describe "#float" do
    it "should return a Literal" do
      subject.float(1.5).should be_kind_of(SQL::Literal)
    end

    it "should convert the value to a Float" do
      subject.float('1.5').value.should == 1.5
    end
  end

  describe "#float" do
    it "should return a Literal" do
      subject.string('A').should be_kind_of(SQL::Literal)
    end

    it "should convert the value to a String" do
      subject.string(42).value.should == '42'
    end
  end
end
