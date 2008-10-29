require 'ronin/code/sql/values_clause'

require 'helpers/code'

shared_examples_for "has a values clause" do
  it "should have a values clause" do
    values = [1,'bob','secret']

    @sql.values(*values)

    should_have_clause(@sql,:values) do |clause|
      clause.values.should == values
    end
  end
end
