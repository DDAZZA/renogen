module Renogen
  module Rules
    module Validators
      # Represents a validation error
      class ValidationError
        attr_reader :message, :rule

        def initialize(message:, rule:)
          @message = message
          @rule = rule
        end
      end
    end
  end
end
