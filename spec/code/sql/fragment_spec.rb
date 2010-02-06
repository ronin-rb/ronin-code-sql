require 'ronin/code/sql/fragment'

require 'spec_helper'

describe Code::SQL::Fragment do
  it "should encode fragments with no elements" do
    frag = Code::SQL::Fragment.new([])

    frag.to_s.should == ''
  end

  it "should encode fragments with one element" do
    frag = Code::SQL::Fragment.new([:id])

    frag.to_s.should == 'id'
  end

  it "should encode fragments with more than one element" do
    frag = Code::SQL::Fragment.new([:drop_table, :users])

    frag.to_s.should == 'drop_table users'
  end
end
