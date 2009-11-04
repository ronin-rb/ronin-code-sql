require 'ronin/code/sql/from_clause'

require 'spec_helper'
require 'code/sql/helpers/sql'

shared_examples_for "has a from clause" do
  include Helpers

  it "should have a from clause" do
    @sql.from :users

    should_have_clause(@sql,:from) do |from|
      from.table.should == :users
    end
  end
end
