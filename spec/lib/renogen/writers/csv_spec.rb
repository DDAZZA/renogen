# frozen_string_literal: true

require 'spec_helper'

describe Renogen::Writers::Csv do
  let(:formatter) { Renogen::Formatters::Csv.new }

  subject { Renogen::Writers::Csv.new(formatter) }

  describe '#write!' do
    let(:expected_output) do
      <<~EOS
        Group 1,Group 2
        "This is a Group 1 change","This is a Group 2 change"
      EOS
    end

    let(:change_1) { renogen_change('Group 1', '') }
    let(:change_2) { renogen_change('Group 2', '') }
    let(:changelog) { Renogen::ChangeLog::Model.new }

    before do
      [change_1, change_2].each { |c| changelog.add_change(c) }
      changelog.add_file({
        'Group 1' => 'This is a Group 1 change',
        'Group 2' => 'This is a Group 2 change'
      })
      $stdout = StringIO.new
    end

    after do
      $stdout = STDOUT
    end

    it 'writes all CSV lines' do
      subject.write!(changelog)
      $stdout.rewind
      expected_output.split("\n").each do |line|
        expect($stdout.gets.strip).to eq(line)
      end
    end
  end
end

