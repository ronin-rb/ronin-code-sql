require 'spec_helper'
require 'ronin/sql/emittable'
require 'ronin/sql/literal'

describe SQL::Emittable do
  subject { SQL::Literal.new('hello') }

  describe "#emitter" do
    it "should return an SQL::Emitter" do
      subject.emitter.should be_kind_of(SQL::Emitter)
    end

    it "should accept Emitter options" do
      subject.emitter(case: :lower).case.should == :lower
    end
  end

  describe "#to_sql" do
    it "should emit the object" do
      subject.to_sql.should == "'hello'"
    end

    context "when given options" do
      it "should pass them to #emitter" do
        subject.to_sql(quotes: :double).should == '"hello"'
      end
    end
  end

  describe "#to_s" do
    it "should call #to_sql with no arguments" do
      subject.to_s.should == subject.to_sql
    end
  end

  describe "#inspect" do
    it "should call #to_sql with no arguments" do
      subject.inspect.should include(subject.to_sql)
    end
  end
end
