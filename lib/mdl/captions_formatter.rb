module MDL
  class CaptionsFormatter
    AV_KEYS = %w(audio video).freeze
    private_constant :AV_KEYS

    class << self
      def format(doc)
        entry_id = AV_KEYS.filter_map { |k| doc[k].presence }.first
        return unless entry_id

        ::FetchCaptionService.fetch(entry_id.strip)
      end
    end
  end
end
