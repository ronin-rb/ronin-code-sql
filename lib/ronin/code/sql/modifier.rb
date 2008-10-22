module Ronin
  module Code
    module SQL
      class Modifier

        include Emitable

        def initialize(expr,name)
          @expr = expr
          @name = name
        end

        def emit
          emit_value(@expr) + emit_keyword(@name)
        end
      end
    end
  end
end
