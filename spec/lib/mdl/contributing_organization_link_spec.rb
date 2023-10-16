require 'rails_helper'
require_relative '../../../lib/mdl/contributing_organization_link'

module MDL
  describe ContributingOrganizationLink do
    describe '.resolve' do
      context 'when the link exists in the config file' do
        it 'returns a fully-qualified URL' do
          result = described_class.resolve('American Craft Council')
          uri = URI(result)
          expect(uri.scheme).to eq('https')
          expect(uri.host).to eq('mndigital.org')
          expect(uri.path).to eq('/about/contributing-organizations/american-craft-council')
        end
      end

      context 'when no link exists in the config file' do
        it 'returns nil' do
          result = described_class.resolve('American Craft Pencil')
          expect(result).to eq(nil)
        end
      end
    end
  end
end
