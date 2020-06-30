# frozen_string_literal: true

module Support
  module RenogenHelper
    def renogen_change(group_name, change)
      Renogen::ChangeLog::Item.new(group_name, change)
    end
  end
end
