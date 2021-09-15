require_relative '../../../lib/mdl/borealis_asset.rb'
require_relative '../../../lib/mdl/borealis_assets_viewer.rb'
require_relative '../../../lib/mdl/borealis_image.rb'
require_relative '../../../lib/mdl/borealis_open_seadragon.rb'

module MDL
  describe BorealisOpenSeadragon do
    let(:images) do
      [
        BorealisImage.new(collection: 'foo', id: '123', title: 'Page One', transcript: 'Page One stuff here'),
        BorealisImage.new(collection: 'foo', id: '312', title: 'Page Two', transcript: 'Page Two stuff here'),
        BorealisImage.new(collection: 'foo', id: '321', title: 'Page Three', transcript: 'Page Three stuff here')
      ]
    end
    let(:openseadragon) { BorealisOpenSeadragon.new(assets: images) }

    it 'correctly identifies its src' do
      expect(openseadragon.to_viewer).to eq (
        {
          "viewerColumnsSmall"=>"col-xs-12 col-sm-8",
          "sidebarColumnsLarge"=>"col-xs-12 col-sm-4",
          "viewerColumnsLarge"=>"col-xs-12 col-sm-9",
          "sidebarColumnsSmall"=>"col-xs-12 col-sm-3",
          "type"=>"image",
          "basename"=>"image",
          "thumbnail"=>"/thumbnails/foo:123",
          "label"=>"Image",
          "transcripts"=>[
            "Page One stuff here",
            "Page Two stuff here",
            "Page Three stuff here"
          ],
          "osdConfig"=>{
            "setStrings"=>[{:name=>"Tooltips.Home", :value=>"Reset"}],
            "include_controls"=>true,
            "sequenceMode"=>true,
            "showReferenceStrip"=>false,
            "defaultZoomLevel"=>0,
            :minZoomLevel=>0,
            "tileSources"=>[
              "/contentdm-images/info?id=foo:123",
              "/contentdm-images/info?id=foo:312",
              "/contentdm-images/info?id=foo:321"
            ]
          },
          "getImageURL"=>"https://cdm16022.contentdm.oclc.org/utils/ajaxhelper",
          "pages"=>[
            {
              :id=>"123",
              :collection=>"foo",
              :transcripts=>["Page One stuff here"],
              :transcript=>"Page One \n Page One stuff here",
              :title=>"Page One",
              :subtitle=>nil,
              :assets=>[],
              :thumbnail=>"/thumbnails/foo:123",
              "id"=>0,
              "viewer"=>"OSD_VIEWER",
              "cdmCollection"=>"foo",
              "cdmIdentifier"=>"123",
              "sidebarThumbnail"=>"/thumbnails/foo:123",
              "infoURL"=>"https://cdm16022.contentdm.oclc.org/digital/iiif/foo/123/info.json"
            },
            {
              :id=>"312",
              :collection=>"foo",
              :transcripts=>["Page Two stuff here"],
              :transcript=>"Page Two \n Page Two stuff here",
              :title=>"Page Two",
              :subtitle=>nil,
              :assets=>[],
              :thumbnail=>"/thumbnails/foo:312",
              "id"=>1,
              "viewer"=>"OSD_VIEWER",
              "cdmCollection"=>"foo",
              "cdmIdentifier"=>"312",
              "sidebarThumbnail"=>"/thumbnails/foo:312",
              "infoURL"=>"https://cdm16022.contentdm.oclc.org/digital/iiif/foo/312/info.json"
            },
            {
              :id=>"321",
              :collection=>"foo",
              :transcripts=>["Page Three stuff here"],
              :transcript=>"Page Three \n Page Three stuff here",
              :title=>"Page Three",
              :subtitle=>nil,
              :assets=>[],
              :thumbnail=>"/thumbnails/foo:321",
              "id"=>2,
              "viewer"=>"OSD_VIEWER",
              "cdmCollection"=>"foo",
              "cdmIdentifier"=>"321",
              "sidebarThumbnail"=>"/thumbnails/foo:321",
              "infoURL"=>"https://cdm16022.contentdm.oclc.org/digital/iiif/foo/321/info.json"
            }
          ],
          "transcript"=>{
            "texts"=>[
              "Page One stuff here",
              "Page Two stuff here",
              "Page Three stuff here"
            ],
            "label"=>"Image"
          }
        }
      )
    end
  end
end
