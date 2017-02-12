module Renogen
  module Rules
    module Validators
      # Rule validator that ensures an item is a String
      class String < Base
        def self.handles?(config)
          'String' == config['type']
        end

        private

        def expected_type?(contents)
          contents.is_a?(::String)
        end

        register(self)
      end
    end
  end
end
