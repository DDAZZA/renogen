require 'spec_helper'

describe Renogen::ExtractionStratagies::YamlFile::Provider do
  it "is returned for 'yaml_file'" do
    expect(Renogen::ExtractionStratagies.obtain(:yaml_file)).to be_a described_class
  end

  it "is returned for 'yaml'" do
    expect(Renogen::ExtractionStratagies.obtain(:yaml)).to be_a described_class
  end

end
