require 'spec_helper'
require 'ronin/sql/emittable'
require 'ronin/sql/literal'

describe SQL::Emittable do
  subject { SQL::Literal.new('hello') }

  describe "#emitter" do
    it "should return an SQL::Emitter" do
      expect(subject.emitter).to be_kind_of(SQL::Emitter)
    end

    it "should accept Emitter options" do
      expect(subject.emitter(case: :lower).case).to eq(:lower)
    end
  end

  describe "#to_sql" do
    it "should emit the object" do
      expect(subject.to_sql).to eq("'hello'")
    end

    context "when given options" do
      it "should pass them to #emitter" do
        expect(subject.to_sql(quotes: :double)).to eq('"hello"')
      end
    end
  end

  describe "#to_s" do
    it "should call #to_sql with no arguments" do
      expect(subject.to_s).to eq(subject.to_sql)
    end
  end

  describe "#inspect" do
    it "should call #to_sql with no arguments" do
      expect(subject.inspect).to include(subject.to_sql)
    end
  end
end
