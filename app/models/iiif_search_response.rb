class IiifSearchResponse
  class Match
    ATTRIBUTES = %w(id item_id line canvas_id word_boundaries highlights)
    attr_accessor *ATTRIBUTES.map(&:to_sym)
    attr_reader :words

    def initialize(args)
      ATTRIBUTES.each do |attr|
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

    def text_match
      matching_words.join(' ')
    end

    def text_before
      line_match && line_match[:before].strip
    end

    def text_after
      line_match && line_match[:after].strip
    end

    def line_match
      @line_match ||= line.match(%r{(?<before>.*)#{text_match}(?<after>.*)})
    end

    def text_match_coords
      first_idx = words.find_index.with_index do |word, i|
        word.include?(matching_words.first) && words[i + matching_words.size - 1].include?(matching_words.last)
      end
      last_idx = first_idx + matching_words.size - 1
      word_boundaries[first_idx.to_s].slice('x0', 'y0').merge(
        word_boundaries[last_idx.to_s].slice('x1', 'y1')
      )
    end

    def matching_words
      @matching_words ||= highlights[0].scan(/<em>(.*?)<\/em>/).map(&:first)
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
      hash['within']['total'] = response['numFound']
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
    URI.escape(
      "https://collection.mndigital.org/iiif/#{item_id}/search?q=#{query}"
    )
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
    @matches ||= docs.map do |doc|
      Match.new(doc).tap do |m|
        m.highlights = highlighting[m.id]['line']
      end
    end
  end
end
