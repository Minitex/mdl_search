module MDL
  class KalturaPlaylistDataFormatter
    class << self
      def format(doc)
        playlist_id = doc['audioa'].presence || doc['videoa'].presence
        playlist = fetch_playlist(playlist_id) || return
        data = playlist.playlist_content.split(',').map do |playlist_entry_id|
          id = playlist_entry_id.strip
          entry = KalturaMediaEntryService.get(id)
          {
            entry_id: id,
            duration: entry.duration,
            name: entry.name
          }
        end

        JSON.generate(data)
      end

      private

      def fetch_playlist(playlist_id)
        return unless playlist_id.present?
        KalturaMediaEntryService.get(playlist_id)
      rescue Kaltura::KalturaAPIError => e
        Rails.logger.error(e.message)
        Sentry.capture_message(
          'Kaltura playlist not found',
          extra: { playlist_id: }
        )
        nil
      end
    end
  end
end
