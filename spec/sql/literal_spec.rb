require 'spec_helper'
require 'ronin/sql/literal'

describe SQL::Literal do
  describe "#to_sql" do
    subject { described_class.new("hello") }

    it "should emit the value" do
      subject.to_sql.should == "'hello'"
    end
  end
end
