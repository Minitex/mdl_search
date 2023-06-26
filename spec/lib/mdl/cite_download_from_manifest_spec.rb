require 'spec_helper'
require_relative '../../../lib/mdl/cite_download_assets_from_manifest'
require_relative '../../../lib/mdl/download_asset'

module MDL
  describe CiteDownloadAssetsFromManifest do
    describe '.call' do
      context 'with a v2 manfest' do
        let(:manifest) do
          { '@context' => 'http://iiif.io/api/presentation/2/context.json' }
        end

        it 'delegates correctly' do
          expect(DownloadAsset).to receive(:assets_from_manifest_v2)
            .with(manifest)
            .and_return(:mock_assets)
          expect(described_class.call(manifest)).to eq(:mock_assets)
        end
      end

      context 'with a v3 manifest' do
        let(:manifest) do
          { '@context' => 'http://iiif.io/api/presentation/3/context.json' }
        end

        it 'delegates correctly' do
          expect(DownloadAsset).to receive(:assets_from_manifest_v3)
            .with(manifest)
            .and_return(:mock_assets)
          expect(described_class.call(manifest)).to eq(:mock_assets)
        end
      end
    end
  end
end
