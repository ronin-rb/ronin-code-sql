require 'spec_helper'
require 'ronin/code/sql'

describe Ronin::Code::SQL do
  it "must include SQL::Mixin" do
    expect(subject).to include(Ronin::Code::SQL::Mixin)
  end

  describe ".sql" do
    it "should return a new SQL::StatementList" do
      expect(subject.sql).to be_kind_of(Ronin::Code::SQL::StatementList)
    end
  end

  describe ".sqli" do
    it "should return a new SQL::Injection" do
      expect(subject.sqli).to be_kind_of(Ronin::Code::SQL::Injection)
    end
  end
end
