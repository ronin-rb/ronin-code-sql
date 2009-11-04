require 'ronin/code/sql/create'

require 'code/sql/has_fields_clause_examples'

shared_examples_for "Create" do
  it_should_behave_like "has a fields clause"

  it "should have a temp option" do
    @sql.temp!
    @sql.should be_temp
  end

  it "should have a if_not_exists option" do
    @sql.if_not_exists!
    @sql.should be_if_not_exists
  end
end
