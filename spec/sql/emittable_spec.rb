require 'spec_helper'
require 'ronin/code/sql/emittable'
require 'ronin/code/sql/literal'

describe Ronin::Code::SQL::Emittable do
  subject { Ronin::Code::SQL::Literal.new('hello') }

  describe "#emitter" do
    it "must return an Ronin::Code::SQL::Emitter" do
      expect(subject.emitter).to be_kind_of(Ronin::Code::SQL::Emitter)
    end

    it "must accept Emitter options" do
      expect(subject.emitter(case: :lower).case).to eq(:lower)
    end
  end

  describe "#to_sql" do
    it "must emit the object" do
      expect(subject.to_sql).to eq("'hello'")
    end

    context "when given options" do
      it "must pass them to #emitter" do
        expect(subject.to_sql(quotes: :double)).to eq('"hello"')
      end
    end
  end

  describe "#to_s" do
    it "must call #to_sql with no arguments" do
      expect(subject.to_s).to eq(subject.to_sql)
    end
  end

  describe "#inspect" do
    it "must call #to_sql with no arguments" do
      expect(subject.inspect).to include(subject.to_sql)
    end
  end
end
