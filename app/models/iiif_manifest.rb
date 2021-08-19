class IiifManifest
  ANNOTATION_DATA_BY_TYPE = {
    MDL::BorealisVideo => {
      type: 'Video',
      format: 'video/mp4',
      width: 640,
      height: 480
    },
    MDL::BorealisAudio => {
      type: 'Sound',
      format: 'audio/mp4'
    }
  }

  delegate :collection,
           :id,
           :title,
           :assets,
           to: :borealis_document

  attr_reader :borealis_document

  def initialize(borealis_document)
    @borealis_document = borealis_document
  end

  def as_json(*)
    {
      '@context' => 'http://iiif.io/api/presentation/3/context.json',
      'id' => "#{base_identifier}/manifest.json",
      'type' => 'Manifest',
      'label' => {
        'en' => [title]
      },
      'rights' => borealis_document.rights_uri,
      'provider' => [{
        'id' => provider_id,
        'type' => 'Agent',
        'label' => {
          'en' => provider_label
        }
      }],
      'metadata' => details.map do |detail|
        {
          'label' => {
            'en' => [detail[:label]]
          },
          'value' => {
            'en' => detail[:field_values].map { |v| v[:text] }
          }
        }
      end,
      'items' => canvasable_assets.map.with_index { |a, idx| canvas(a, idx) }
    }.tap do |hsh|
      if renderable_assets.any?
        hsh['rendering'] = renderable_assets.map { |a| rendering(a) }
      end
    end
  end

  private

  def details
    MDL::CiteDetails.new(
      solr_doc: borealis_document.document
    ).details
  end

  def base_identifier
    "https://collection.mndigital.org/iiif/info/#{collection}/#{id}"
  end

  def canvas(asset, canvas_num)
    canvas_id = "#{base_identifier}/canvas/#{canvas_num}"
    {
      'id' => canvas_id,
      'type' => 'Canvas',
      'items' => [
        {
          'id' => "#{canvas_id}/page",
          'type' => 'AnnotationPage',
          'items' => [
            {
              'id' => "#{canvas_id}/page/annotation",
              'type' => 'Annotation',
              'motivation' => 'painting',
              'body' => {
                'id' => asset.src,
                'type' => annotation_body_type(asset),
                'duration' => borealis_document.duration,
                'format' => annotation_body_format(asset)
              },
              'target' => canvas_id
            }
          ]
        }
      ]
    }.tap do |hsh|
      if single_av_media?
        hsh['duration'] = borealis_document.duration
        width, height = annotation_aspect(asset)

        if width && heigth
          hsh['height'] = height
          hsh['width'] = width

          hsh['items'][0]['items'][0]['body']['height'] = height
          hsh['items'][0]['items'][0]['body']['width'] = width
        end
      end
    end
  end

  def rendering(asset)
    {
      'id' => asset.src,
      'type' => 'Text',
      'label' => {
        'en' => ['PDF Transcript']
      },
      'format' => 'application/pdf'
    }
  end

  def canvasable_assets
    assets.select do |a|
      [MDL::BorealisVideo, MDL::BorealisAudio].include?(a.class)
    end
  end

  def renderable_assets
    assets.select { |a| a.is_a?(MDL::BorealisPDF) }
  end

  ###
  # Until we can get playlist components' duration values indexed,
  # we have to consider only single audio and video documents to
  # be valid A/V media. UniversalViewer will require a more complex
  # manifest for a playlist
  def single_av_media?
    [
      'kaltura_audio',
      'kaltura_video'
    ].include?(borealis_document.initial_viewer_type)
  end

  def annotation_body_type(asset)
    ANNOTATION_DATA_BY_TYPE.fetch(asset.class)[:type]
  end

  def annotation_body_format(asset)
    ANNOTATION_DATA_BY_TYPE.fetch(asset.class)[:format]
  end

  def annotation_aspect(asset)
    ANNOTATION_DATA_BY_TYPE.fetch(asset.class).values_at(:width, :height)
  end

  def provider_id
    contact_info.match(/(http.*)/).to_s
  end

  def provider_label
    (contact_info.sub(provider_id, '')).split(',').map(&:strip)
  end

  def contact_info
    borealis_document.document['contact_information_ssi']
  end
end
