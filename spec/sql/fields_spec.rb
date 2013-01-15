require 'spec_helper'
require 'ronin/sql/fields'

describe SQL::Fields do
  subject { Object.new.extend(described_class) }

  describe "#method_missing" do
    let(:name) { 'users' }

    context "when called with no arguments and no block" do
      it "should create a Field" do
        subject.send(name).name.should == name
      end
    end

    context "when called with arguments" do
      it "should raise a NoMethodError" do
        lambda {
          subject.sned(name,1,2,3)
        }.should raise_error(NoMethodError)
      end
    end

    context "when called with a block" do
      it "should raise a NoMethodError" do
        lambda {
          subject.sned(name) { 1 + 1 }
        }.should raise_error(NoMethodError)
      end
    end
  end
end
