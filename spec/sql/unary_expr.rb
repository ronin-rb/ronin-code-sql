require 'spec_helper'
require 'ronin/sql/unary_expr'

describe SQL::UnaryExpr do
  describe "#to_sql" do
    subject { described_class.new(:NOT,:admin) }

    it "should emit a binary expression" do
      subject.to_sql.should == "NOT admin"
    end
  end
end
