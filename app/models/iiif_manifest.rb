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
    },
    MDL::BorealisPdf => {
      type: 'Text',
      format: 'application/pdf'
    },
    MDL::BorealisImage => {
      type: 'Image',
      format: 'image/jpeg'
    }
  }.freeze
  private_constant :ANNOTATION_DATA_BY_TYPE
  RENDERABLE_ASSET_CLASSES = ANNOTATION_DATA_BY_TYPE.keys.freeze
  private_constant :RENDERABLE_ASSET_CLASSES
  AV_ASSETS = [MDL::BorealisVideo, MDL::BorealisAudio].freeze
  private_constant :AV_ASSETS

  delegate :collection,
           :id,
           :title,
           :assets,
           to: :borealis_document

  # @return [MDL::BorealisDocument]
  attr_reader :borealis_document

  # @return [String]
  attr_reader :base_url

  ###
  # @param borealis_document [MDL::BorealisDocument]
  # @param base_url [String]
  def initialize(borealis_document, base_url:)
    @borealis_document = borealis_document
    @base_url = base_url
  end

  ###
  # @return [Hash]
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
      'items' => canvasable_assets.map(&method(:canvas))
    }.tap do |hsh|
      if borealis_document.document['rights_statement_ssi']
        hsh['requiredStatement'] = {
          'label' => 'Attribution',
          'value' => borealis_document.document['rights_statement_ssi']
          }
      end
      if renderable_assets.any?
        hsh['rendering'] = renderable_assets.flat_map(&method(:rendering))
      end
      if rangeable_assets.any?
        hsh['structures'] = rangeable_assets
          .map
          .with_index { |a, idx| structure(a, idx) }
      end
    end
  end

  private

  def details
    MDL::CiteDetails
      .new(solr_doc: borealis_document.document)
      .details
  end

  def base_identifier
    "#{base_url}/iiif/info/#{collection}/#{id}"
  end

  def canvas(asset)
    id = canvas_id(asset)
    {
      'id' => id,
      'type' => 'Canvas',
      'items' => [
        {
          'id' => "#{id}/page",
          'type' => 'AnnotationPage',
          'items' => annotation_items(asset, id)
        }
      ],
      'thumbnail' => [
        {
          'id' => asset.thumbnail_url,
          'type' => 'Image',
          'format' => 'image/png',
          'width' => 160,
          'height' => 160
        }
      ]
    }.tap do |hsh|
      if asset.playlist?
        hsh['duration'] = asset.playlist_data.sum { |d| d['duration'] }
      else
        hsh['duration'] = borealis_document.duration
        if supports_captions?(asset)
          hsh['rendering'] = [
            {
              'id' => "#{base_url}/tracks/#{collection}:#{borealis_document.id}.vtt",
              'type' => 'Text',
              'label' => { 'en' => ['English'] },
              'format' => 'text/vtt'
            },
            {
              'id' => asset.src,
              'type' => annotation_body_type(asset),
              'duration' => borealis_document.duration,
              'format' => annotation_body_format(asset)
            }
          ]
        end
      end
      width, height = annotation_aspect(asset)

      if width && height
        hsh['height'] = height
        hsh['width'] = width

        hsh['items'][0]['items'][0]['body']['height'] = height
        hsh['items'][0]['items'][0]['body']['width'] = width
      end
    end
  end

  def annotation_items(asset, canvas_id)
    if asset.playlist?
      playlist_annotation_items(asset, canvas_id)
    else
      single_annotation_item(asset, canvas_id)
    end
  end

  def single_annotation_item(asset, canvas_id)
    [
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
  end

  def playlist_annotation_items(asset, canvas_id)
    width, height = annotation_aspect(asset)
    type = annotation_body_type(asset)
    body_format = annotation_body_format(asset)
    start = 0
    asset.playlist_data.map.with_index do |data, idx|
      finish = start + data['duration']
      target = "#{canvas_id}#t=#{start},#{finish}"
      start = finish
      {
        'id' => "#{canvas_id}/page/annotation/#{idx}",
        'type' => 'Annotation',
        'motivation' => 'painting',
        'body' => {
          'id' => asset.src(data['entry_id']),
          'type' => type,
          'format' => body_format,
          'duration' => data['duration']
        }.tap do |hsh|
          hsh['width'] = width if width
          hsh['height'] = height if height
        end,
        'target' => target
      }
    end
  end

  def rendering(asset)
    if asset.playlist?
      asset.playlist_data.map.with_index do |data, idx|
        {
          'id' => asset.src(data['entry_id']),
          'type' => annotation_body_type(asset),
          'label' => {
            'en' => ["#{asset.title} Part #{idx + 1}"]
          },
          'format' => annotation_body_format(asset)
        }
      end
    else
      [{
        'id' => asset.src,
        'type' => annotation_body_type(asset),
        'label' => {
          'en' => [asset.title]
        },
        'format' => annotation_body_format(asset),
        'thumbnail' => [
          {
            'id' => asset.thumbnail_url,
            'type' => 'Image',
            'format' => 'image/jpeg'
          }
        ]
      }]
    end
  end

  def supports_captions?(asset)
    AV_ASSETS.include?(asset.class) && !asset.playlist?
  end

  def structure(asset, range_index)
    range_id = "#{base_identifier}/range/#{range_index}"
    canvas_id = canvas_id(asset)
    start = 0
    {
      'type' => 'Range',
      'id' => range_id,
      'label' => {
        'en' => [title]
      },
      'items' => asset.playlist_data.map.with_index do |data, idx|
        finish = start + data['duration']
        target = "#{canvas_id}#t=#{start},#{finish}"
        start = finish
        {
          'type' => 'Range',
          'id' => "#{range_id}.#{idx}",
          'label' => {
            'en' => [data['name']]
          },
          'items' => [
            {
              'type' => 'Canvas',
              'id' => target
            }
          ]
        }
      end
    }
  end

  def canvas_id(asset)
    "#{base_identifier}/canvas/#{canvasable_assets.index(asset)}"
  end

  def canvasable_assets
    assets.select do |a|
      AV_ASSETS.include?(a.class)
    end
  end

  def renderable_assets
    assets.select do |a|
      RENDERABLE_ASSET_CLASSES.include?(a.class)
    end
  end

  def rangeable_assets
    canvasable_assets.select { |a| a.playlist_data.any? }
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
