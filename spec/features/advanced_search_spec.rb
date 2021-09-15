require 'rails_helper'

describe 'advanced search' do
  describe 'transcript search' do
    before do
      VCR.use_cassette('ingest_sll:22470') do
        Ingestion.ingest_record('sll:22470')
      end
      VCR.use_cassette('ingest_otter:297') do
        Ingestion.ingest_record('otter:297')
      end
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
