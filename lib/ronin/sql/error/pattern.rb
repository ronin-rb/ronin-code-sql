require 'ronin/sql/error/message'

module Ronin
  module SQL
    module Error
      class Pattern

        # Name of the pattern
        attr_reader :name

        # Name of the SQL dialect
        attr_accessor :dialect

        # Patterns to use for matching SQL errors
        attr_reader :patterns

        #
        # Creates a new Pattern object with the specified _name_. If a
        # _block_ is given, it will be passed the newly created Pattern
        # object.
        #
        def initialize(name,&block)
          @dialect = :common
          @name = name.to_sym
          @patterns = []

          block.call(self) if block
        end

        #
        # Returns all defined SQL Pattern objects.
        #
        def Pattern.patterns
          @@patterns ||= {}
        end

        #
        # Defines a new SQL Pattern object with the given _options_.
        #
        def Pattern.pattern(name,&block)
          pattern = (Pattern.patterns[name] ||= Pattern.new(name))

          block.call(pattern) if block
          return pattern
        end

        #
        # Returns the SQL Pattern objects with the specified _names_.
        #
        def Pattern.patterns_for(*names)
          names.map { |name| Pattern.patterns[name] }.compact
        end

        #
        # Returns the SQL Pattern objects for the dialect with the
        # specified _name_.
        #
        def Pattern.patterns_for_dialect(name)
          Pattern.patterns.values.select do |pattern|
            pattern.dialect == name
          end
        end

        #
        # Returns the first matching Error object to the specified _data_.
        # If no Pattern objects match the specified _data_, +nil+ will
        # be returned.
        #
        def Pattern.match(data)
          Pattern.patterns.each_value do |pattern|
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
              return Message.new(@type,@dialect,match[0])
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
end
