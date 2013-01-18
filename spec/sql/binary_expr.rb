require 'spec_helper'
require 'ronin/sql/binary_expr'

describe SQL::BinaryExpr do
  describe "#to_sql" do
    subject { described_class.new(:id,:=,1) }

    it "should emit a binary expression" do
      subject.to_sql.should == "id=1"
    end
  end
end
