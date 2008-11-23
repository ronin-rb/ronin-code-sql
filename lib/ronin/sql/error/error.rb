require 'ronin/sql/error/pattern'

module Ronin
  module SQL
    module Error
      #
      # Returns all defined SQL Pattern objects.
      #
      def Error.patterns
        @@ronin_sql_error_patterns ||= {}
      end

      #
      # Defines a new SQL Pattern object with the given _options_.
      #
      def Error.pattern(name,&block)
        pattern = (Error.patterns[name] ||= Pattern.new(name))

        block.call(pattern) if block
        return pattern
      end

      #
      # Returns the SQL Pattern objects with the specified _names_.
      #
      def Error.patterns_for(*names)
        names.map { |name| Error.patterns[name] }.compact
      end

      #
      # Returns the SQL Pattern objects for the dialect with the
      # specified _name_.
      #
      def Error.patterns_for_dialect(name)
        Error.patterns.values.select do |pattern|
          pattern.dialect == name
        end
      end
    end
  end
end
