require 'ronin/code/sql/fragment'

require 'spec_helper'
require 'code/sql/helpers/fragment'

describe Code::SQL::Fragment do
  include Helpers::Fragment

  it "should allow appending elements en-mass" do
    fragment = sql[1, :eq, 1]

    fragment.elements.should == [1, :eq, 1]
  end

  it "should allow appending elements individually" do
    fragment = sql
    fragment << 1
    fragment << :eq
    fragment << 1

    fragment.elements.should == [1, :eq, 1]
  end

  it "should allow access to the tokens" do
    sql[1, :eq, 1].tokens.should == ['1', '=', '1']
  end

  describe "to_sql" do
    it "should encode a single Integer" do
      sql[10].to_sql.should == '10'
    end

    it "should encode a single Float" do
      sql[0.5].to_sql.should == '0.5'
    end

    it "should encode a single true" do
      sql[true].to_sql.should == 'true'
    end

    it "should encode a single false" do
      sql[false].to_sql.should == 'false'
    end

    it "should encode a single nil" do
      sql[nil].to_sql.should == 'null'
    end

    it "should encode a single String" do
      sql['hello'].to_sql.should == "\"hello\""
    end

    it "should encode a single Symbol" do
      sql[:id].to_sql.should == "id"
    end

    it "should encode an aliased keyword" do
      sql[:eq].to_sql.should == "="
    end

    it "should encode an empty Array" do
      sql[[]].to_sql.should == "()"
    end

    it "should encode a singleton Array" do
      sql[[1]].to_sql.should == "1"
    end

    it "should encode a single Array" do
      sql[[1,2,3]].to_sql.should == "(1,2,3)"
    end

    it "should encode an empty Hash" do
      sql[{}].to_sql.should == "()"
    end

    it "should encode a singleton Hash" do
      sql[{:count => 5}].to_sql.should == "count=5"
    end

    it "should encode a single Hash" do
      update = {:user => 'bob', :password => 'lol'}

      sql[update].to_sql.should == "(user=\"bob\",password=\"lol\")"
    end

    it "should encode multiple elements" do
      sql[1, :eq, 1].to_sql.should == "1 = 1"
    end
  end
end
