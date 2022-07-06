require 'rails_helper'

describe 'advanced search' do
  xdescribe 'transcript search' do
    before do
      solr_fixtures('sll:22470', 'otter:297')
    end

    it 'can find a record by text contained in its transcript' do
      pending 'Transcript is temporarily excluded from advanced search'
      visit '/'
      click_link 'Advanced Search'
      fill_in 'Transcript', with: '"fifty percent cut"'
      click_button "Search"
      expect(page).to have_content('Interview with Glenn Kelley')
      expect(page).to_not have_content('A. Aberle residence, 214 South Peck Street, Fergus Falls, Minnesota')
    end
  end
end
