require 'ronin/code/sql/modifier'

module Ronin
  module Code
    module SQL
      class Asc < Modifier

        def initialize(expr)
          super(expr,'ASC')
        end

      end
    end
  end
end
