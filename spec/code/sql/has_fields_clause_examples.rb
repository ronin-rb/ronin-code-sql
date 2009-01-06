require 'ronin/code/sql/fields_clause'

require 'helpers/code'

shared_examples_for "has a fields clause" do
  it "should have a fields clause" do
    fields = [:id, :name, :users]

    @sql.fields(*fields)

    should_have_clause(@sql,:fields) do |clause|
      clause.fields.should == fields
    end
  end
end
