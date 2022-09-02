require 'spec_helper'
require 'ronin/code/sql'

describe Ronin::Code::SQL do
  subject { Object.new.extend(described_class) }

  describe "#sql" do
    it "should return a new SQL::StatementList" do
      expect(subject.sql).to be_kind_of(Ronin::Code::SQL::StatementList)
    end
  end

  describe "#sqli" do
    it "should return a new SQL::Injection" do
      expect(subject.sqli).to be_kind_of(Ronin::Code::SQL::Injection)
    end
  end
end
