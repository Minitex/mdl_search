require 'rails_helper'
require_relative '../../../lib/mdl/multi_date_formatter'

module MDL
  describe IiifManifestUrlFormatter do
    describe '.format' do
      let(:doc) do
        { 'id' => 'abc/123' }
      end

      it 'returns a relative URL path' do
        result = described_class.format(doc)
        expect(result).to eq('/iiif/abc:123/manifest.json')
      end
    end
  end
end
