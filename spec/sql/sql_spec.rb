require 'spec_helper'

require 'ronin/sql/sql'

describe SQL do
  it "should allow creating fragments" do
    frag = subject[1, :eq, 1]

    frag.should be_kind_of(SQL::Fragment)
  end

  it "should allow creating functions" do
    func = subject.max(:users)

    func.should be_kind_of(SQL::Function)
  end
end
