require 'spec_helper'
require 'ronin/sql/errors'

describe SQL::Errors do
  it "should provide error signatures" do
    subject.signatures.should_not be_empty
  end
end
