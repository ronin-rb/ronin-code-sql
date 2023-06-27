require 'spec_helper'
require 'sql/statement_examples'
require 'ronin/code/sql/statement'
require 'ronin/code/sql/statements'

describe Ronin::Code::SQL::Statements do
  subject { Object.new.extend(described_class) }

  describe "#statement" do
    let(:keyword) { :EXEC }

    it "must create an arbitrary statement" do
      expect(subject.statement(keyword).keyword).to eq(keyword)
    end
  end

  include_examples "Statement", :select, :SELECT, [1,2,3,:id]
  include_examples "Statement", :insert, :INSERT
  include_examples "Statement", :update, :UPDATE, :table
  include_examples "Statement", :delete, [:DELETE, :FROM], :table
  include_examples "Statement", :drop_table, [:DROP, :TABLE], :table
end
