require 'spec_helper'
require 'ronin/code/sql'

describe Ronin::Code::SQL do
  it "must include SQL::Mixin" do
    expect(subject).to include(Ronin::Code::SQL::Mixin)
  end
end
