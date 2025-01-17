require 'rails_helper'

describe 'advanced search' do
  before do
    solr_fixtures('sll:22470', 'otter:297', 'msn:2277', 'msn:2670', 'msn:2680')
  end

  it 'can find a record by text contained in its transcript' do
    visit '/'
    click_link 'Advanced Search'
    fill_in 'Transcript', with: '"fifty percent cut"'
    click_button "Search"
    expect(page).to have_content('Interview with Glenn Kelley')
    expect(page).to_not have_content('A. Aberle residence, 214 South Peck Street, Fergus Falls, Minnesota')
  end

  it 'respects the given parameters' do
    visit '/'
    page.current_window.resize_to(1200, 1200)
    click_link 'Advanced Search'
    fill_in 'Title', with: '"Streetcar"'
    click_button 'Search'
    page.assert_selector(
      'h3.document-title-heading a em',
      text: 'Streetcar',
      count: 3
    )

    filters = page.all('.applied-filter', count: 1)
    filters.first.find('.filter-name', text: 'Title')
    filters.first.find('.filter-value', text: 'Streetcar')

    type_facet,
    format_facet,
    date_facet,
    subject_facet,
    contributor_facet,
    rights_status_facet = page.all('.facet-limit').map(&:itself)

    expect(type_facet.find('.facet-field-heading').text).to eq('Type')
    expect(type_facet.find('.facet-label').text).to eq('Still Image')
    expect(type_facet.find('.facet-count').text).to eq('3')

    expect(format_facet.find('.facet-field-heading').text).to eq('Physical Format')
    expect(format_facet.find('.facet-label').text).to eq('Black-and-white photographs')
    expect(format_facet.find('.facet-count').text).to eq('3')

    expect(date_facet.find('.facet-field-heading').text).to eq('Date Created')
    expect(date_facet.find('.range_begin').value).to eq('1940')
    expect(date_facet.find('.range_end').value).to eq('1950')
    expect(date_facet).to have_button('Apply')
    expect(date_facet).to have_selector('.slider.slider-horizontal')
    expect(date_facet).to have_selector('.distribution.chart_js')

    expect(subject_facet.find('.facet-field-heading').text).to eq('Subject Headings')
    subject_facet.assert_selector('.facet-label', text: 'Street Railroads')
    subject_facet.assert_selector('.facet-label', text: 'Transportation')

    expect(contributor_facet.find('.facet-field-heading').text).to eq('Contributor')
    expect(contributor_facet.find('.facet-label').text).to eq('Minnesota Streetcar Museum')
    expect(contributor_facet.find('.facet-count').text).to eq('3')

    expect(rights_status_facet.find('.facet-field-heading').text).to eq('Rights Status')
  end
end
