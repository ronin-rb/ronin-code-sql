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

      #
      # Tests whether the _body_ contains an SQL error message using the
      # given _options_.
      #
      # _options_ may contain the following keys:
      # <tt>:dialect</tt>:: The SQL dialect whos error messages to test for.
      # <tt>:types</tt>:: A list of error pattern types to test for.
      #
      def Error.message(body,options={})
        if options[:dialect]
          patterns = Error.patterns_for_dialect(options[:dialect])
        elsif options[:types]
          patterns = Error.patterns_for(*options[:types])
        else
          patterns = Error.patterns.values
        end

        patterns.each do |pattern|
          if (message = pattern.match(body))
            return message
          end
        end

        return nil
      end
    end
  end
end
