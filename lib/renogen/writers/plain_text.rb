# frozen_string_literal: true

module Renogen
  module Writers
    # Writes out the change log in plain text format
    class PlainText < Base
      register :text, :plain_text
    end
  end
end
