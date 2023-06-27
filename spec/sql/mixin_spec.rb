require 'spec_helper'
require 'ronin/code/sql/mixin'

describe Ronin::Code::SQL::Mixin do
  module TestMixin
    class TestClass
      include Ronin::Code::SQL::Mixin
    end
  end

  let(:test_class) { TestMixin::TestClass }
  subject { test_class.new }

  describe "#sql" do
    it "must return a new SQL::StatementList" do
      expect(subject.sql).to be_kind_of(Ronin::Code::SQL::StatementList)
    end
  end

  describe "#sqli" do
    it "must return a new SQL::Injection" do
      expect(subject.sqli).to be_kind_of(Ronin::Code::SQL::Injection)
    end
  end
end
