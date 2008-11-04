require 'ronin/sql/error'

module Ronin
  module SQL
    class ErrorPattern

      # Name of the pattern
      attr_reader :name

      # Name of the SQL dialect
      attr_accessor :dialect

      # Patterns to use for matching SQL errors
      attr_reader :patterns

      #
      # Creates a new ErrorPattern object with the specified _name_. If a
      # _block_ is given, it will be passed the newly created ErrorPattern
      # object.
      #
      def initialize(name,&block)
        @dialect = :common
        @name = name.to_sym
        @patterns = []

        block.call(self) if block
      end

      #
      # Returns all defined SQL ErrorPattern objects.
      #
      def ErrorPattern.patterns
        @@patterns ||= {}
      end

      #
      # Defines a new SQL ErrorPattern object with the given _options_.
      #
      def ErrorPattern.pattern(name,&block)
        pattern = (ErrorPattern.patterns[name] ||= ErrorPattern.new(name))

        block.call(pattern) if block
        return pattern
      end

      #
      # Returns the SQL ErrorPattern objects with the specified _names_.
      #
      def ErrorPattern.patterns_for(*names)
        names.map { |name| ErrorPattern.patterns[name] }.compact
      end

      #
      # Returns the SQL ErrorPattern objects for the dialect with the
      # specified _name_.
      #
      def ErrorPattern.patterns_for_dialect(name)
        ErrorPattern.patterns.values.select do |pattern|
          pattern.dialect == name
        end
      end

      def ErrorPattern.match(data)
        ErrorPattern.patterns.each_value do |pattern|
          if (error = pattern.match(data))
            return error
          end
        end

        return nil
      end

      #
      # Returns the first match between the error pattern and the specified
      # _data_. If no matches were found +nil+ will be returned.
      #
      def match(data)
        @patterns.each do |pattern|
          if (match = pattern.match(data))
            return Error.new(@type,@dialect,match[0])
          end
        end

        return nil
      end

      #
      # Returns the name of the error pattern.
      #
      def to_s
        @name.to_s
      end

    end
  end
end
