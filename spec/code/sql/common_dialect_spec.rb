require 'ronin/code/sql/common_dialect'

require 'spec_helper'

describe Code::SQL::CommonDialect do
  before(:all) do
    @dialect = Code::SQL::CommonDialect.new
  end

  it "should provide the 'yes' primitive" do
    token = @dialect.yes

    token.class.should == Code::SQL::Token
    token.to_s.should == 'yes'
  end

  it "should provide the 'no' primitive" do
    token = @dialect.no

    token.class.should == Code::SQL::Token
    token.to_s.should == 'no'
  end

  it "should provide the 'on' primitive" do
    token = @dialect.on

    token.class.should == Code::SQL::Token
    token.to_s.should == 'on'
  end

  it "should provide the 'off' primitive" do
    token = @dialect.off

    token.class.should == Code::SQL::Token
    token.to_s.should == 'off'
  end

  it "should provide the 'null' primitive" do
    token = @dialect.null

    token.class.should == Code::SQL::Token
    token.to_s.should == 'null'
  end

  it "should provide the 'int' data-type" do
    token = @dialect.int

    token.class.should == Code::SQL::Token
    token.to_s.should == 'INT'
  end

  it "should provide the 'varchar' data-type" do
    token = @dialect.varchar

    token.class.should == Code::SQL::Token
    token.to_s.should == 'VARCHAR'
  end

  it "should provide the 'varchar' data-type with specific length" do
    token = @dialect.varchar(15)

    token.class.should == Code::SQL::Token
    token.to_s.should == 'VARCHAR(15)'
  end

  it "should provide the 'text' data-type" do
    token = @dialect.text

    token.class.should == Code::SQL::Token
    token.to_s.should == 'TEXT'
  end

  it "should provide the 'record' data-type" do
    token = @dialect.record

    token.class.should == Code::SQL::Token
    token.to_s.should == 'RECORD'
  end

  it "should provide the 'avg' function" do
    func = @dialect.avg(:salary)

    func.name.should == :avg
    func.fields.should == [:salary]
  end

  it "should provide the 'count' function" do
    func = @dialect.count(:id)

    func.name.should == :count
    func.fields.should == [:id]
  end

  it "should provide the 'group_concat' function" do
    func = @dialect.group_concat(:id)

    func.name.should == :group_concat
    func.fields.should == [:id]
  end

  it "should provide the 'min' function" do
    func = @dialect.min(:salary)

    func.name.should == :min
    func.fields.should == [:salary]
  end

  it "should provide the 'max' function" do
    func = @dialect.max(:salary)

    func.name.should == :max
    func.fields.should == [:salary]
  end

  it "should provide the 'sum' function" do
    func = @dialect.sum(:salary)

    func.name.should == :sum
    func.fields.should == [:salary]
  end

  it "should provide the 'total' function" do
    func = @dialect.total(:salary)

    func.name.should == :total
    func.fields.should == [:salary]
  end

  it "should provide the 'create table' statement" do
    stmt = @dialect.create_table(:users)

    stmt.class.should == Code::SQL::CreateTable
    stmt.table.should == :users
  end

  it "should provide the 'create index' statement" do
    stmt = @dialect.create_index(:users_index)

    stmt.class.should == Code::SQL::CreateIndex
    stmt.index.should == :users_index
  end

  it "should provide the 'create view' statement" do
    stmt = @dialect.create_view(:users_view)

    stmt.class.should == Code::SQL::CreateView
    stmt.view.should == :users_view
  end

  it "should provide the 'alter table' statement" do
    stmt = @dialect.alter_table(:users)

    stmt.class.should == Code::SQL::AlterTable
    stmt.table.should == :users
  end

  it "should provide the 'insert' statement" do
    stmt = @dialect.insert(:users)

    stmt.class.should == Code::SQL::Insert
    stmt.table.should == :users
  end

  it "should provide the 'select' statement" do
    stmt = @dialect.select(:from => :users)

    stmt.class.should == Code::SQL::Select
    stmt.from.table.should == :users
  end

  it "should provide the 'update' statement" do
    stmt = @dialect.update(:users)

    stmt.class.should == Code::SQL::Update
    stmt.table.should == :users
  end

  it "should provide the 'delete' statement" do
    stmt = @dialect.delete(:users)

    stmt.class.should == Code::SQL::Delete
    stmt.table.should == :users
  end

  it "should provide the 'drop table' statement" do
    stmt = @dialect.drop_table(:users)

    stmt.class.should == Code::SQL::DropTable
    stmt.table.should == :users
  end

  it "should provide the 'drop index' statement" do
    stmt = @dialect.drop_index(:users_index)

    stmt.class.should == Code::SQL::DropIndex
    stmt.index.should == :users_index
  end

  it "should provide the 'drop view' statement" do
    stmt = @dialect.drop_view(:users_view)

    stmt.class.should == Code::SQL::DropView
    stmt.view.should == :users_view
  end
end
