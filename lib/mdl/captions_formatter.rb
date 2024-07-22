module MDL
  class CaptionsFormatter
    AV_KEYS = %w(audio video audioa videoa).freeze
    private_constant :AV_KEYS

    class << self
      def format(doc)
        entry_ids = AV_KEYS
          .filter_map { |k| doc[k].presence }
          .flat_map { |e| e.split(';') }
        return if entry_ids.empty?

        caption_data = entry_ids.reduce({}) do |acc, entry_id|
          id = entry_id.strip
          vtt_data = ::FetchCaptionService.fetch(entry_id.strip)
          # Correct invalid timestamp format on the VTT data
          vtt_data&.gsub!(/(\d),(\d{3})/, '\1.\2')
          # We sometimes hit encoding errors due to copy/paste, most likely
          acc[id] = vtt_data&.encode(
            'UTF-8',
            invalid: :replace,
            undef: :replace,
            replace: '?'
          )
          acc
        end

        JSON.generate(caption_data)
      end
    end
  end
end
