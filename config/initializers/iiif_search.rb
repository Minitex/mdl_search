blacklight_config = YAML.load(
  ERB.new(IO.read(Rails.root.join('config', 'blacklight.yml'))).result(binding)
)[Rails.env]

blacklight_solr_uri = URI(blacklight_config['url'])

IIIF_SEARCH_SOLR_URL = blacklight_solr_uri.class.build(
  host: blacklight_solr_uri.host,
  port: blacklight_solr_uri.port,
  path: '/solr/mdl-iiif-search'
).to_s
