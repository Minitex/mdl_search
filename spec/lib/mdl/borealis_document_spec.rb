require 'rails_helper'
require_relative '../../../lib/mdl/borealis_document.rb'

module MDL
  describe BorealisDocument do
    let(:document) do
      {'id' => 'foo:123', 'format' => 'image/jp2', 'title_ssi' => 'blerg'}
    end
    let(:compound_document) do
      document.merge('compound_objects_ts' => <<~JSON
        [
          {
            "pageptr": 123,
            "title": "Some thing",
            "transc": "blah",
            "pagefile": "foo.jp2"
          },
          {
            "pageptr": 321,
            "title": "Another Thing",
            "transc": "The text",
            "pagefile": "foo.mp4"
          }
        ]
      JSON
      )
    end
    let(:bogus_pagefile) do
      document.merge('compound_objects_ts' => <<~JSON
        [
          {
            "pageptr": 123,
            "title": "Some thing",
            "transc": "blah",
            "pagefile": {}
          },
         {
            "pageptr": 321,
            "title": "Another Thing",
            "transc": "The text",
            "pagefile": "foo.jp2"
          }
        ]
      JSON
      )
    end

    describe '#assets' do
      context 'with audio doc' do
        let(:document) { FactoryBot.build(:borealis_document, :audio) }

        it 'contains Audio assets' do
          expect(document.assets.size).to eq(2)
          expect(document.assets.map(&:class)).to eq([
            BorealisAudio,
            BorealisPdf,
          ])
        end
      end

      context 'with audio playlist doc' do
        let(:document) { FactoryBot.build(:borealis_document, :audio_playlist) }

        it 'contains Audio assets' do
          expect(document.assets.size).to eq(2)
          expect(document.assets.map(&:class)).to eq([
            BorealisAudio,
            BorealisPdf,
          ])
        end
      end

      context 'with video doc' do
        let(:document) { FactoryBot.build(:borealis_document, :video) }

        it 'contains Video assets' do
          expect(document.assets.size).to eq(2)
          expect(document.assets.map(&:class)).to eq([
            BorealisVideo,
            BorealisPdf,
          ])
        end
      end

      context 'with video playlist doc' do
        let(:document) do
          FactoryBot.build(:borealis_document, :video_playlist)
        end

        it 'contains Video assets' do
          expect(document.assets.size).to eq(2)
          expect(document.assets.map(&:class)).to eq([
            BorealisVideo,
            BorealisPdf,
          ])
        end
      end

      context 'with image doc' do
        let(:document) { FactoryBot.build(:borealis_document, :image) }

        it 'contains Image assets' do
          expect(document.assets.size).to eq(1)
          expect(document.assets.map(&:class)).to eq([BorealisImage])
        end
      end

      context 'when format_tesi is null' do
        before do
          document.document.delete('compound_objects_ts')
          document.document.delete('format_tesi')
        end

        context 'with audio doc' do
          let(:document) { FactoryBot.build(:borealis_document, :audio) }

          it 'contains Audio assets' do
            expect(document.assets.size).to eq(1)
            expect(document.assets.map(&:class)).to eq([BorealisAudio])
          end
        end

        context 'with audio playlist doc' do
          let(:document) { FactoryBot.build(:borealis_document, :audio_playlist) }

          it 'contains Audio assets' do
            expect(document.assets.size).to eq(1)
            expect(document.assets.map(&:class)).to eq([BorealisAudio])
          end
        end

        context 'with video doc' do
          let(:document) { FactoryBot.build(:borealis_document, :video) }

          it 'contains Video assets' do
            expect(document.assets.size).to eq(1)
            expect(document.assets.map(&:class)).to eq([BorealisVideo])
          end
        end

        context 'with video playlist doc' do
          let(:document) { FactoryBot.build(:borealis_document, :video_playlist) }

          it 'contains Video assets' do
            expect(document.assets.size).to eq(1)
            expect(document.assets.map(&:class)).to eq([BorealisVideo])
          end
        end

        context 'with image doc' do
          let(:document) { FactoryBot.build(:borealis_document, :image) }

          it 'contains Image assets' do
            expect(document.assets.size).to eq(1)
            expect(document.assets.map(&:class)).to eq([BorealisImage])
          end
        end
      end
    end

    describe '#manifest_url' do
      subject do
        BorealisDocument.new(document:).manifest_url
      end

      it do
        contentdm_url = 'https://cdm16022.contentdm.oclc.org/iiif/2/foo:123/manifest.json'
        is_expected.to eq(contentdm_url)
      end

      context 'when we have a manifest URL index in Solr' do
        let(:document) do
          super().merge('iiif_manifest_url_ssi' => '/test/manifest.json')
        end

        it { is_expected.to eq('/test/manifest.json') }
      end

      context 'when the document represents A/V media' do
        let(:document) do
          super().merge(
            'compound_objects_ts' => <<~JSON
              [{
                "pageptr": 321,
                "title": "Video Thing",
                "transc": "The text",
                "pagefile": "foo.mp4"
              }]
            JSON
          )
        end

        it { is_expected.to eq('/iiif/foo:123/manifest.json') }
      end
    end
  end
end
