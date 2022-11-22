require 'rails_helper'

describe UpdateIiifManifestServiceDescription do
  describe '#call' do
    let(:response) do
      {
        'response' => {
          'numFound' => 1,
          'docs' => [{
            'id' => 'pch:1224',
            'iiif_manifest_ss' => JSON.generate({
              'service' => {
                '@context' => 'http://iiif.io/api/search/1/context.json',
                '@id' => '/iiif/pch:1224/search',
                'profile' => 'http://iiif.io/api/search/1/search'
              }
            })
          }]
        }
      }
    end
    let(:solr_client) do
      instance_double(RSolr::Client, get: response, add: nil)
    end
    let(:instance) do
      described_class.new('pch:1224', solr_client: solr_client)
    end

    it 'updates the document' do
      instance.call
      update = JSON.generate({
        'service' => {
          '@context' => 'http://iiif.io/api/search/1/context.json',
          '@id' => '/iiif/pch:1224/search',
          'profile' => 'http://iiif.io/api/search/1/search',
          'service' => {
            '@id' => '/iiif/pch:1224/autocomplete',
            'profile' => 'http://iiif.io/api/search/1/autocomplete'
          }
        }
      })
      expect(solr_client).to have_received(:add).with({
        'id' => 'pch:1224',
        'iiif_manifest_ss' => update
      })
    end
  end
end
