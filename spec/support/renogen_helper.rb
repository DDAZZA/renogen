# frozen_string_literal: true

module Support
  module RenogenHelper
    def renogen_change(ticket_id, group_name, change)
      Renogen::ChangeLog::Item.new(ticket_id, group_name, change)
    end
  end
end
