require 'rails_helper'

describe 'Some home page sanity checks' do
  before do
    solr_fixtures('otter:297')
  end

  it 'runs a search' do
    visit '/'
    expect(page).to have_content(/Browse all \d+ items from 189 historical societies, libraries, archives, and cultural organizations across Minnesota/)
    find(:xpath, '//*[@id="search"]').click
    expect(page).to have_content('A. Aberle residence, 214 South Peck Street, Fergus Falls, Minnesota')
  end
end

