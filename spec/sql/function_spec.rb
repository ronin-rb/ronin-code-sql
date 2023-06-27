require 'spec_helper'

require 'ronin/code/sql/function'

describe Ronin::Code::SQL::Function do
  describe "#initialize" do
    context "with no arguments" do
      subject { described_class.new(:f) }

      it "must set arguments to []" do
        expect(subject.arguments).to eq([])
      end
    end

    context "with multiple arguments" do
      let(:arguments) { [1,2,3] }

      subject { described_class.new(:f,*arguments) }

      it "must set arguments" do
        expect(subject.arguments).to eq(arguments)
      end
    end
  end
end
