module Renogen
  # Custom exceptions throw by the libary
  module Exceptions
    require_relative 'exceptions/base'
    require_relative 'exceptions/extraction_stratagy_not_found'
    require_relative 'exceptions/formatter_not_found'
  end
end
