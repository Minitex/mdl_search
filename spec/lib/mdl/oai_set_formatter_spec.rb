require 'spec_helper'
require_relative '../../../lib/mdl/oai_set_formatter'

module MDL
  describe OaiSetFormatter do
    describe '.format' do
      it 'returns a value that represents setSpec ID, collection ID, and collection name joined with a delimiter' do
        doc = {
          'setSpec' => 'foo',
          'oai_sets' => {
            'foo' => {
              name: 'theSetName',
              description: 'The set description and all that good stuff'
            }
          }
        }
        expected = 'foo||theSetName||The set description and all that good stuff'

        expect(OaiSetFormatter.format(doc)).to eq expected
      end
    end
  end
end
