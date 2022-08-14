class IiifSearchResponse
  class Match
    DOCUMENT_ATTRIBUTES = %w(item_id line canvas_id word_boundaries)
    HIGHLIGHT = /<em>(.*?)<\/em>/.freeze

    class << self
      def expand(doc, highlights)
        match_indices = highlighted_line(doc['line'], highlights).split(' ')
          .each_with_object([])
          .with_index do |(word, acc), idx|
            acc << idx if word.match?(HIGHLIGHT)
          end

        match_indices.chunk_while { |i1, i2| i1 + 1 == i2 }.map do |index_group|
          new(doc).tap { |m|
            m.match_index = index_group.first
            m.word_count = index_group.size
            m.text_match = doc['line'].split(' ').values_at(*index_group).join(' ')
          }
        end
      end

      private

      ###
      # The highlight we get from Solr may be only a subset
      # of the line. This will combine the highlight with the line
      # so that we can get an accurate index of the highlighted
      # words within it.
      def highlighted_line(line, highlights)
        cleaned_hl = highlights.gsub(/<\/?em>/, '')
        line_parts = line.partition(cleaned_hl)
        hl_idx = line_parts.index(cleaned_hl)
        line_parts[hl_idx] = highlights
        line_parts.map(&:strip).join(' ')
      end
    end

    attr_accessor *DOCUMENT_ATTRIBUTES.map(&:to_sym)
    attr_accessor :match_index, :text_match, :word_count
    attr_reader :words

    def initialize(args)
      DOCUMENT_ATTRIBUTES.each do |attr|
        self.send("#{attr}=", args[attr])
      end
      @words = line.split(' ')
    end

    def annotation_id
      annotation_path = canvas_id.scan(%r{#{item_id}.*$}).first
      "https://collection.mndigital.org/annotations/#{annotation_path}/h#{xywh}"
    end

    def xywh
      @xywh ||= begin
        coords = text_match_coords
        x, y = coords.values_at('x0', 'y0')
        w = coords['x1'] - x
        h = coords['y1'] - y
        "#{x},#{y},#{w},#{h}"
      end
    end

    def text_before
      words[0...match_index].join(' ')
    end

    def text_after
      words[(match_index + word_count)..-1].join(' ')
    end

    def text_match_coords
      first_idx = match_index.to_s
      last_idx = (match_index + word_count - 1).to_s
      word_boundaries[first_idx].slice('x0', 'y0').merge(
        word_boundaries[last_idx].slice('x1', 'y1')
      )
    end
  end

  CONTEXT = 'http://iiif.io/api/search/1/context.json'.freeze

  attr_reader :solr_response, :item_id, :query

  def initialize(solr_response, item_id:, query:)
    @solr_response = solr_response
    @item_id = item_id
    @query = query
  end

  def as_json(*)
    base_response.tap do |hash|
      hash['within']['total'] = matches.size
      hash['resources'] = build_resources
      hash['hits'] = build_hits
    end
  rescue => e
    ###
    # If something goes wrong, fall back to an empty response
    # so the UI doesn't get stuck. If we were to just return a
    # 500, UniversalViewer would get into an unrecoverable
    # error state that would require a page refresh to fix.
    Rails.logger.error("#{e.message}\n#{e.backtrace.take(5).join("\n")}")
    base_response
  end

  private

  def base_response
    {
      '@context' => CONTEXT,
      '@id' => id,
      '@type' => 'sc:AnnotationList',
      'within' => {
        '@type' => 'sc:Layer',
        'total' => 0
      },
      'startIndex' => 0, # Pagination not yet supported
      'resources' => [],
      'hits' => [],
    }
  end

  def build_resources
    matches.map do |match|
      {
        '@id' => match.annotation_id,
        '@type' => 'oa:Annotation',
        'motivation' => 'sc:painting',
        'resource' => {
          '@type' => 'cnt:ContentAsText',
          'chars' => match.text_match
        },
        'on' => "#{match.canvas_id}#xywh=#{match.xywh}"
      }
    end
  end

  def build_hits
    matches.map do |match|
      {
        '@type' => 'search:Hit',
        'annotations' => [match.annotation_id],
        'match' => match.text_match,
        'before' => match.text_before,
        'after' => match.text_after
      }
    end
  end

  def id
    q = URI.encode_www_form_component(query)
    "https://collection.mndigital.org/iiif/#{item_id}/search?q=#{q}"
  end

  def response
    solr_response['response']
  end

  def docs
    response['docs']
  end

  def highlighting
    solr_response['highlighting']
  end

  def matches
    @matches ||= docs.flat_map do |doc|
      highlights = highlighting[doc['id']]['line'].first
      Match.expand(doc, highlights)
    end
  end
end
