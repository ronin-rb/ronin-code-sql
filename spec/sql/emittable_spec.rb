require 'spec_helper'
require 'ronin/sql/emittable'

describe SQL::Emittable do
  subject { Object.new.extend(described_class) }

  describe "#emitter" do
    it "should return an SQL::Emitter" do
      subject.emitter.should be_kind_of(SQL::Emitter)
    end

    it "should accept Emitter options" do
      subject.emitter(:case => :lower).case.should == :lower
    end
  end

  describe "#to_sql" do
    it "should raise NotImplementedError" do
      lambda { subject.to_sql }.should raise_error(NotImplementedError)
    end
  end

  describe "#to_s" do
    it "should call #to_sql with no arguments" do
      subject.should_receive(:to_sql).with()

      subject.to_s
    end
  end

  describe "#to_str" do
    it "should call #to_sql with no arguments" do
      subject.should_receive(:to_sql).with()

      subject.to_str
    end
  end

  describe "#inspect" do
    it "should call #to_sql with no arguments" do
      subject.should_receive(:to_sql).with()

      subject.inspect
    end
  end
end
