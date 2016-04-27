require 'spec_helper'

describe Renogen do
  let(:extraction_stratagy) { double(extract: []) }
  let(:formatter) { double(write: true) }

  describe '.generate' do
    # instance_double(Renogen::ExtractionStratagies, obtain: extraction_stratagy)
  end
end
