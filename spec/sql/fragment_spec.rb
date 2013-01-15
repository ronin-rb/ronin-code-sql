require 'spec_helper'

require 'ronin/sql/fragment'
require 'ronin/sql/function'

describe SQL::Fragment do
  describe "#to_sql" do
    it "should encode fragments with no elements" do
      frag = described_class.new []

      frag.to_sql.should == ''
    end

    it "should encode fragments with one element" do
      frag = described_class.new [:id]

      frag.to_sql.should == 'id'
    end

    it "should encode fragments with more than one element" do
      frag = described_class.new [:drop_table, :users]

      frag.to_sql.should == 'drop_table users'
    end
  end
end
