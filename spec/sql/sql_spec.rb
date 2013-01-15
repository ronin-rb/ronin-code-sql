require 'spec_helper'
require 'ronin/sql/sql'

describe SQL do
  subject { Object.new.extend(described_class) }

  describe "#sql" do
    it "should return a new SQL::Program" do
      subject.sql.should be_kind_of(SQL::Program)
    end
  end

  describe "#sqli" do
    it "should return a new SQL::Injection" do
      subject.sqli.should be_kind_of(SQL::Injection)
    end
  end
end
