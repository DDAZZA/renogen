module Renogen
  module Rules
    module Validators
      # Rule validator that ensures an item is a boolean
      class Boolean < Base
        # @param config [Hash]
        #
        # @return [true, false] true when config['type'] == 'Boolean'
        def self.handles?(config)
          'Boolean' == config['type']
        end

        private

        def expected_type?(contents)
          contents === true || contents === false
        end

        register(self)
      end
    end
  end
end
