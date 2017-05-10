# A wrapper around a solr bounding box query
class Nearby
  def self.search(q: '*:*', pt: '46.7296,-94.6859', d: 40)
    Blacklight.default_index.connection.get('select',
      :params => { :q => "#{q} -coordinates_llsi:\"#{pt}\"",
        :d => d,
        :pt => pt,
        :fl => '*',
        :fq => '{!bbox sfield=coordinates_llsi}',
        :defType => 'edismax',
        :rows => 200
      })['response']['docs']
    rescue StandardError => e
      Rails.logger.error("Nearby Error: #{e}")
      []
  end
end

