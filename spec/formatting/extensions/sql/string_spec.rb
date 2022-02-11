require 'spec_helper'
require 'ronin/formatting/extensions/sql/string'

describe "ronin/formatting/extensions/sql/string" do
  let(:root) { File.expand_path('../../../..',__dir__) }
  let(:path) { File.join(root,'lib','ronin','format','core_ext','sql','string.rb') }

  it "must require 'ronin/format/core_ext/sql/string'" do
    expect($LOADED_FEATURES).to include(path)
  end
end
