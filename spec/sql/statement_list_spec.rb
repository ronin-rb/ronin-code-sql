require 'spec_helper'
require 'ronin/code/sql/statement_list'

describe Ronin::Code::SQL::StatementList do
  describe "#initialize" do
    context "when given a block" do
      subject do
        described_class.new { @x = 1 }
      end

      it "must instance_eval the block" do
        expect(subject.instance_variable_get(:@x)).to eq(1)
      end

      context "that accepts an argument" do
        it "must yield itself" do
          yielded_statement_list = nil

          described_class.new do |statement_list|
            yielded_statement_list = statement_list
          end

          expect(yielded_statement_list).to be_kind_of(described_class)
        end
      end
    end
  end

  describe "#<<" do
    let(:keyword) { :SELECT }

    before { subject << Ronin::Code::SQL::Statement.new(keyword) }

    it "must append a new statement" do
      expect(subject.statements.last.keyword).to eq(keyword)
    end
  end

  describe "#statement" do
    let(:keyword) { [:ALTER, :TABLE] }

    before { subject.statement(keyword) }

    it "must create and append a new Statement" do
      expect(subject.statements.last.keyword).to eq(keyword)
    end
  end
end
