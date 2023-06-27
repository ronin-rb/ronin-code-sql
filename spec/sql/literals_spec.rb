require 'spec_helper'
require 'ronin/code/sql/literals'

describe Ronin::Code::SQL::Literals do
  subject { Object.new.extend(described_class) }

  describe "#null" do
    it "must return a Literal" do
      expect(subject.null).to be_kind_of(Ronin::Code::SQL::Literal)
    end

    it "must have the value of :NULL" do
      expect(subject.null.value).to eq(:NULL)
    end
  end

  describe "#int" do
    it "must return a Literal" do
      expect(subject.int(5)).to be_kind_of(Ronin::Code::SQL::Literal)
    end

    it "must convert the value to an Integer" do
      expect(subject.int('5').value).to eq(5)
    end
  end

  describe "#float" do
    it "must return a Literal" do
      expect(subject.float(1.5)).to be_kind_of(Ronin::Code::SQL::Literal)
    end

    it "must convert the value to a Float" do
      expect(subject.float('1.5').value).to eq(1.5)
    end
  end

  describe "#float" do
    it "must return a Literal" do
      expect(subject.string('A')).to be_kind_of(Ronin::Code::SQL::Literal)
    end

    it "must convert the value to a String" do
      expect(subject.string(42).value).to eq('42')
    end
  end
end
