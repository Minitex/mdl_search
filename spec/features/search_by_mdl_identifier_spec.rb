require 'rails_helper'

describe 'searching by MDL identifier' do
  context 'in a compound document' do
    before { solr_fixtures('spl:3207') }

    it 'links to the right page in the document' do
      visit '/'
      fill_in 'q', with: 'mhs64801'
      click_on 'Search'
      result_link = find_link('A Statewide Movement for the Collection and Preservation of Minnesota\'s War Records')
      result_link.click

      expect(current_path).to eq('/catalog/spl:3207')
      expect(all('.autocompleteText').size).to eq(1)

      page_input = page.find('.autocompleteText')
      expect(page_input.value).to eq('9')
    end
  end
end
