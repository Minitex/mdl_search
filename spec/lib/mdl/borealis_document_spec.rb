require_relative '../../../lib/mdl/borealis_asset.rb'
require_relative '../../../lib/mdl/borealis_assets_viewer.rb'
require_relative '../../../lib/mdl/borealis_image.rb'
require_relative '../../../lib/mdl/borealis_audio.rb'
require_relative '../../../lib/mdl/borealis_video.rb'
require_relative '../../../lib/mdl/borealis_video_player.rb'
require_relative '../../../lib/mdl/borealis_pdf.rb'
require_relative '../../../lib/mdl/borealis_open_seadragon.rb'
require_relative '../../../lib/mdl/borealis_assets_to_viewers.rb'
require_relative '../../../lib/mdl/borealis_asset_map.rb'
require_relative '../../../lib/mdl/borealis_document.rb'
require_relative '../../../lib/mdl/borealis_ppt.rb'
module MDL
  describe BorealisDocument do
    let(:asset_klass) { double }
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

    context 'when the document is a single item' do
      it 'correctly serializes the document' do
        expect(BorealisDocument.new(document: document).to_viewer).to eq (
          {
            "image"=>{
              "viewerColumnsSmall"=>"col-xs-12 col-sm-8",
              "sidebarColumnsLarge"=>"col-xs-12 col-sm-4",
              "viewerColumnsLarge"=>"col-xs-12 col-sm-9",
              "sidebarColumnsSmall"=>"col-xs-12 col-sm-3",
              "type"=>"image",
              "basename"=>"image",
              "thumbnail"=>"/thumbnails/foo:123",
              "label"=>"Image",
              "transcripts"=>[],
              "osdConfig"=>{
                "setStrings"=>[{:name=>"Tooltips.Home", :value=>"Reset"}],
                "include_controls"=>true,
                "sequenceMode"=>true,
                "showReferenceStrip"=>false,
                "defaultZoomLevel"=>0,
                :minZoomLevel=>0,
                "tileSources"=>["/contentdm-images/info?id=foo:123"]
              },
              "getImageURL"=>"https://cdm16022.contentdm.oclc.org/utils/ajaxhelper",
              "pages"=>[
                {
                  :id=>"123",
                  :collection=>"foo",
                  :transcripts=>[],
                  :transcript=>"blerg \n ",
                  :title=>"blerg",
                  :subtitle=>nil,
                  :assets=>[],
                  :thumbnail=>"/thumbnails/foo:123",
                  "id"=>0,
                  "viewer"=>"OSD_VIEWER",
                  "cdmCollection"=>"foo",
                  "cdmIdentifier"=>"123",
                  "sidebarThumbnail"=>"/thumbnails/foo:123",
                  "infoURL"=>"https://cdm16022.contentdm.oclc.org/digital/iiif/foo/123/info.json"
                }
              ],
              "transcript"=>{
                "texts"=>[],
                "label"=>"Image"
              }
            }
          }
        )
      end
    end

    context 'when the document is a compound item' do
      it 'serializes the documents' do
        expect(BorealisDocument.new(document: compound_document).to_viewer).to eq (
          {
            "image"=> {
              "viewerColumnsSmall"=>"col-xs-12 col-sm-8",
              "sidebarColumnsLarge"=>"col-xs-12 col-sm-4",
              "viewerColumnsLarge"=>"col-xs-12 col-sm-9",
              "sidebarColumnsSmall"=>"col-xs-12 col-sm-3",
              "type"=>"image",
              "basename"=>"image",
              "thumbnail"=>"/thumbnails/foo:123",
              "label"=>"Image",
              "transcripts"=>["blah"],
              "osdConfig"=>{
                "setStrings"=>[{:name=>"Tooltips.Home", :value=>"Reset"}],
                "include_controls"=>true,
                "sequenceMode"=>true,
                "showReferenceStrip"=>false,
                "defaultZoomLevel"=>0,
                :minZoomLevel=>0,
                "tileSources"=>["/contentdm-images/info?id=foo:123"]
              },
              "getImageURL"=>"https://cdm16022.contentdm.oclc.org/utils/ajaxhelper",
              "pages"=>[
                {
                  :id=>123,
                  :collection=>"foo",
                  :transcripts=>["blah"],
                  :transcript=>"Some thing \n blah",
                  :title=>"Some thing",
                  :subtitle=>nil,
                  :assets=>[],
                  :thumbnail=>"/thumbnails/foo:123",
                  "id"=>0,
                  "viewer"=>"OSD_VIEWER",
                  "cdmCollection"=>"foo",
                  "cdmIdentifier"=>123,
                  "sidebarThumbnail"=>"/thumbnails/foo:123",
                  "infoURL"=>"https://cdm16022.contentdm.oclc.org/digital/iiif/foo/123/info.json"
                }
              ],
              "transcript"=>{"texts"=>["blah"],
              "label"=>"Image"}
            },
            "kaltura_video"=> {
              "type"=>"kaltura_video",
              "targetId"=>"kaltura_player_video",
              "wid"=>"_1369852",
              "uiconf_id"=>38683631,
              "transcript"=>{"texts"=>["The text"],
              "label"=>"Video"},
              "entry_id"=>false,
              "wrapper_height"=>"100%",
              "wrapper_width"=>"100%",
              "thumbnail"=>"/images/video-1.png"
            }
          }
        )
      end

      it 'rejects bad page page file data' do
        pages = BorealisDocument.new(document: bogus_pagefile).to_viewer['image']['pages']
        expect(pages).to eq(
          [
            {
              :id=>321,
              :collection=>"foo",
              :transcripts=>["The text"],
              :transcript=>"Another Thing \n The text",
              :title=>"Another Thing",
              :subtitle=>nil,
              :assets=>[],
              :thumbnail=>"/thumbnails/foo:321",
              "id"=>0,
              "viewer"=>"OSD_VIEWER",
              "cdmCollection"=>"foo",
              "cdmIdentifier"=>321,
              "sidebarThumbnail"=>"/thumbnails/foo:321",
              "infoURL"=>"https://cdm16022.contentdm.oclc.org/digital/iiif/foo/321/info.json"
            }
          ]
        )
      end
    end
  end
end
