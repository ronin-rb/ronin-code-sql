module Ronin
  module Code
    module SQL
      class Modifier

        include Emittable

        def initialize(expr,name)
          @expr = expr
          @name = name
        end

        def emit
          emit_value(@expr) + emit_token(@name)
        end
      end
    end
  end
end
