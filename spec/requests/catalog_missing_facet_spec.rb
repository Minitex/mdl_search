require 'rails_helper'

#
# Blacklight uses Lucene's query semantics around searching
# for records that don't have a value for a specific field.
# This test verifies that it works, since we have some logic
# in RenderConstraintsOverrideOverride that makes some
# adjustments to the filter constraints rendering.
#
describe 'handling the "missing" facet' do
  it 'renders without erroring' do
    get('/?q=&range[-dat_ssim][]=[*+TO+*]&search_field=all_fields')
    expect(response).to have_http_status(:ok)
  end
end
