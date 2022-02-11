require 'spec_helper'
require 'ronin/formatting/extensions/sql'

describe "ronin/formatting/extensions/sql" do
  let(:root) { File.expand_path('../../..',__dir__) }
  let(:path) { File.join(root,'lib','ronin','format','core_ext','sql.rb') }

  it "must require 'ronin/format/core_ext/sql'" do
    expect($LOADED_FEATURES).to include(path)
  end
end
