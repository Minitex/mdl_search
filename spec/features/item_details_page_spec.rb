require 'rails_helper'

describe 'item details' do
  before do
    solr_fixtures('otter:297')
  end

  it 'has a link to browse the collection' do
    visit '/catalog/otter:297'

    contributing_org_link = page.find_link(
      href: 'https://mndigital.org/about/contributing-organizations/otter-tail-county-historical-society'
      )
    expect(contributing_org_link).to have_text('Otter Tail County Historical Society')

    click_link 'Browse the Otter Tail County Historical Society collection'

    filters = page.all('.applied-filter', count: 1)
    filters.first.find('.filter-name', text: 'Contributing Organization')
    filters.first.find('.filter-value', text: 'Otter Tail County Historical Society')
  end
end
