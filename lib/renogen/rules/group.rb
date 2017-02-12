module Renogen
  module Rules
    # Describes rules for a single group of changelog items
    class Group
      # Returns the rule for the given group name or the general rule if there is none for the given name
      #
      # @param group_name [String]
      #
      # @return [Renogen::Rules::Group, nil] The Group that applies to the given group name or nil if there is none
      def self.validator_for(group_name)
        group_rules[group_name] || group_rules[:'*']
      end

      private

      def self.config
        Renogen::Config.instance
      end

      def self.group_rules
        config.group_rules
      end
    end
  end
end
