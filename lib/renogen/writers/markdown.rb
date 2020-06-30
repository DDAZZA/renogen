# frozen_string_literal: true

module Renogen
  module Writers
    # Writes out the change log in markdown format
    class Markdown < Base
      register :markdown, :md
    end
  end
end
