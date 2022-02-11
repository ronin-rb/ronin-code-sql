require 'spec_helper'
require 'ronin/formatting/sql'

describe "ronin/formatting/sql" do
  let(:root) { File.expand_path('../..',__dir__) }
  let(:path) { File.join(root,'lib','ronin','format','sql.rb') }

  it "must require 'ronin/format/sql'" do
    expect($LOADED_FEATURES).to include(path)
  end
end
