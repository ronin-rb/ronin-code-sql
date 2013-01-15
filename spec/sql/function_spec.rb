require 'spec_helper'

require 'ronin/sql/function'

describe SQL::Function do
  describe "#initialize" do
    context "with no arguments" do
      subject { described_class.new(:f) }

      it "should set arguments to []" do
        subject.arguments.should == []
      end
    end

    context "with multiple arguments" do
      let(:arguments) { [1,2,3] }

      subject { described_class.new(:f,*arguments) }

      it "should set arguments" do
        subject.arguments.should == arguments
      end
    end
  end
end
