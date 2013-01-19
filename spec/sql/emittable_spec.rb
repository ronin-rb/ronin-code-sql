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
end
