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
        # Add the specified _pattern_ to be used to recognize SQL error
        # messages.
        #
        def recognize(pattern)
          @patterns << pattern
          return self
        end

        #
        # Returns the first match between the error pattern and the
        # specified _data_. If no matches were found +nil+ will be
        # returned.
        #
        def match(data)
          data = data.to_s

          @patterns.each do |pattern|
            match = data.match(pattern)

            return Message.new(@name,@dialect,match[0]) if match
          end

          return nil
        end

        #
        # Returns the match index within the specified _data_ where a SQL
        # error Pattern occurs. If no SQL error Pattern can be found within
        # _data_, +nil+ will be returned.
        #
        def =~(data)
          data = data.to_s

          @patterns.each do |pattern|
            if (index = (pattern =~ data))
              return index
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
