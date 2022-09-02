require 'spec_helper'
require 'ronin/sql/operators'
require 'sql/binary_expr_examples'
require 'sql/unary_expr_examples'

describe Ronin::SQL::Operators do
  subject { Object.new.extend(described_class) }

  let(:operand) { 1 }

  include_examples "BinaryExpr", :*
  include_examples "BinaryExpr", :/
  include_examples "BinaryExpr", :%
  include_examples "BinaryExpr", :+
  include_examples "BinaryExpr", :-
  include_examples "BinaryExpr", :<<
  include_examples "BinaryExpr", :>>
  include_examples "BinaryExpr", :&
  include_examples "BinaryExpr", :|
  include_examples "BinaryExpr", :<
  include_examples "BinaryExpr", :<=
  include_examples "BinaryExpr", :>
  include_examples "BinaryExpr", :>=
  include_examples "BinaryExpr", :==, :"="
  include_examples "BinaryExpr", :!=
  include_examples "BinaryExpr", :as, :AS
  include_examples "BinaryExpr", :is, :IS
  include_examples "BinaryExpr", :is_not, [:IS, :NOT]
  include_examples "BinaryExpr", :like, :LIKE
  include_examples "BinaryExpr", :glob, :GLOB
  include_examples "BinaryExpr", :match, :MATCH
  include_examples "BinaryExpr", :regexp, :REGEXP
  include_examples "BinaryExpr", :in, :IN

  include_examples "UnaryExpr", :-@, :-
  include_examples "UnaryExpr", :+@, :+

  include_examples "UnaryExpr", :~
  include_examples "UnaryExpr", :!
  include_examples "UnaryExpr", :not, :NOT

  include_examples "BinaryExpr", :and, :AND
  include_examples "BinaryExpr", :or, :OR
end
