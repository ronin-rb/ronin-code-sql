require 'spec_helper'
require 'ronin/sql/sql'

describe SQL do
  subject { Object.new.extend(described_class) }

  describe "#sql" do
    it "should return a new SQL::StatementList" do
      expect(subject.sql).to be_kind_of(SQL::StatementList)
    end
  end

  describe "#sqli" do
    it "should return a new SQL::Injection" do
      expect(subject.sqli).to be_kind_of(SQL::Injection)
    end
  end
end
