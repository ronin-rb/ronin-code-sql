require 'ronin/code/sql/create_view'

require 'code/sql/create_examples'

describe CreateView do
  before(:each) do
    @sql = CreateView.new(common_dialect)
  end

  it_should_behave_like "Create"
end
