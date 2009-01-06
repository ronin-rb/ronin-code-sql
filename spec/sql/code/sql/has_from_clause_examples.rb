require 'ronin/code/sql/from_clause'

require 'helpers/code'

shared_examples_for "has a from clause" do
  it "should have a from clause" do
    @sql.from :users

    should_have_clause(@sql,:from) do |from|
      from.table.should == :users
    end
  end
end
