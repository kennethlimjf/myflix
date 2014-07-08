require 'spec_helper'

describe ApplicationHelper do
  describe '#star_options' do
    it 'should give options' do
      expect(star_options).to eq [["", nil], ["1 Star", 1], ["2 Stars", 2], ["3 Stars", 3], ["4 Stars", 4], ["5 Stars", 5]]
    end
  end
end