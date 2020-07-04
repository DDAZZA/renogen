# frozen_string_literal: true

require 'spec_helper'

describe Renogen::Formatters::Csv do
  describe 'write_methods' do
    let(:change_1) { renogen_change(1, 'Group 1', 'Change 1') }
    let(:change_2) { renogen_change(1, 'Group 2', 'Change 2') }
    let(:change_3) { renogen_change(2, 'Group 1', 'Change 3') }
    let(:changelog) { Renogen::ChangeLog::Model.new }

    before do
      [change_1, change_2, change_3].each { |c| changelog.add_change(c) }
      subject.header(changelog)
    end

    it { is_expected.to be_table_formatter }
    describe '#write_header' do
      it 'returns a comma separated list of group names' do
        expect(subject.write_header('Group 1,Group 2')).to eq("Group 1,Group 2\n")
      end
    end

    describe '#write_change' do
      let(:ticket) do
        {
          'Group 1' => 'This is a Group 1 change',
          'Group 2' => 'This is a Group 2 change, with a comma'
        }
      end

      context 'when ticket contains same keys as changelog groups' do
        it 'outputs all values' do
          expect(subject.write_change(ticket)).to eq(
            'This is a Group 1 change,"This is a Group 2 change, with a comma"'
          )
        end
      end

      context 'when changelog contains keys missing in ticket' do
        it 'outputs empty values for missing keys' do
          expect(subject.write_change(ticket)).to eq(
            'This is a Group 1 change,"This is a Group 2 change, with a comma"'
          )
        end
      end
    end
  end
end
