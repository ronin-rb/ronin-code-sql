require 'spec_helper'
require 'ronin/code/sql/field'

describe Ronin::Code::SQL::Field do
  describe "#initialize" do
    it "must convert name to a String" do
      expect(described_class.new(:table).name).to eq('table')
    end

    it "must default parent to nil" do
      expect(described_class.new('table').parent).to be_nil
    end
  end

  describe "parse" do
    context "when passed a single field" do
      let(:name) { "column" }

      subject { described_class.parse(name) }

      it "must parse the field name" do
        expect(subject.name).to eq(name)
      end

      it "must not have a parent" do
        expect(subject.parent).to be_nil
      end
    end

    context "when parsing multiple fields" do
      let(:parent) { "table"  }
      let(:name)   { "column" }

      subject { described_class.parse("#{parent}.#{name}") }

      it "must parse the field name" do
        expect(subject.name).to eq(name)
      end

      it "must parse the parent field" do
        expect(subject.parent.name).to eq(parent)
      end
    end
  end

  describe "#to_s" do
    context "when parent is nil" do
      let(:name) { "column" }

      subject { described_class.new(name) }

      it "must return the name" do
        expect(subject.to_s).to eq(name)
      end
    end

    context "when parent is set" do
      let(:parent) { "table"  }
      let(:name)   { "column" }

      subject { described_class.new(name,described_class.new(parent)) }

      it "must return the name" do
        expect(subject.to_s).to eq("#{parent}.#{name}")
      end
    end
  end

  describe "#method_missing" do
    context "at depth 1" do
      subject { described_class.new('table') }

      it "must allow accessing sub-fields" do
        expect(subject.column.name).to eq('column')
      end
    end

    context "at depth 2" do
      subject { described_class.new('table',described_class.new('db')) }

      it "must allow accessing sub-fields" do
        expect(subject.column.name).to eq('column')
      end
    end

    context "at depth 3" do
      subject do
        described_class.new(
          'column',
          described_class.new(
            'table', described_class.new('db')
          )
        )
      end

      it "must not allow accessing sub-fields" do
        expect {
          subject.column
        }.to raise_error(NoMethodError)
      end
    end
  end
end
