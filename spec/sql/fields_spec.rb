require 'spec_helper'
require 'ronin/sql/fields'

describe SQL::Fields do
  subject { Object.new.extend(described_class) }

  describe "#respond_to_missing?" do
    it "should return true" do
      expect(subject.respond_to?(double(:method))).to be(true)
    end
  end

  it { expect(subject.to_ary).to be_nil }

  describe "#method_missing" do
    let(:name) { 'users' }

    context "when called with no arguments and no block" do
      it "should create a Field" do
        expect(subject.send(name).name).to eq(name)
      end
    end

    context "when called with arguments" do
      it "should raise a NoMethodError" do
        expect {
          subject.sned(name,1,2,3)
        }.to raise_error(NoMethodError)
      end
    end

    context "when called with a block" do
      it "should raise a NoMethodError" do
        expect {
          subject.sned(name) { 1 + 1 }
        }.to raise_error(NoMethodError)
      end
    end
  end
end
