# frozen_string_literal: true

require 'spec_helper'

describe Renogen::Formatters::Csv do
  describe '#write_ methods' do
    let(:change_1) { renogen_change('Group 1', 'Change 1') }
    let(:change_2) { renogen_change('Group 2', 'Change 2') }
    let(:changes) { [change_1, change_2] }
    let(:changelog) { Renogen::ChangeLog::Model.new }

    before do
      changes.each { |c| changelog.add_change(c) }
    end

    describe '#write_headings' do
      it 'returns a comma separated list of group names' do
        expect(subject.write_headings(changelog)).to eq('Group 1,Group 2')
      end
    end

    describe '#write_file' do
      let(:file) do
        {
          'Group 1' => 'This is a Group 1 change',
          'Group 2' => 'This is a Group 2 change'
        }
      end

      context 'when file contains same keys as changelog groups' do
        it 'outputs all values' do
          expect(subject.write_file(file, changelog)).to eq(
            '"This is a Group 1 change","This is a Group 2 change"'
          )
        end
      end

      context 'when changelog contains keys missing in file' do
        let(:change_3) { renogen_change('Group 3', 'Change 3') }
        let(:changes) { [change_1, change_2, change_3] }

        it 'outputs empty values for missing keys' do
          expect(subject.write_file(file, changelog)).to eq(
            '"This is a Group 1 change","This is a Group 2 change",""'
          )
        end
      end
    end
  end
end
