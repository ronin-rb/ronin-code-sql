require 'ronin/code/sql/where_clause'

require 'spec_helper'
require 'code/sql/helpers/sql'

shared_examples_for "has a where clause" do
  include Helpers

  it "should have a where clause" do
    @sql.instance_eval do
      where name == 'bob'
    end

    should_have_clause(@sql,:where) do |clause|
      clause.expr.should_not be_nil
    end
  end
end
