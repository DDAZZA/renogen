# Renogen is a development tool.
# It makes it easier and faster to produce changelogs and release notes
# It works by stopping merge confics and decouping the change notes from releaes versions
module Renogen
  require 'renogen/version'
  require 'renogen/exceptions'
  require 'renogen/formatters'
  require 'renogen/extraction_stratagies'
  require 'renogen/change_log'
  require 'renogen/generator'
  require 'renogen/config'
  require 'renogen/rules'
end
