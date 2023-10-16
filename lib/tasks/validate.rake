namespace :validate do
  desc <<~DESC
    Check that the contributing organizations in Solr match
    those we scraped from the Drupal site. If there are differences,
    we likely need to update the anchor text in the differing links
    in Drupal so that they match what's stored in Solr. That way, we
    can match the names up and return links to Drupal from an item's
    details page.
  DESC
  task contributing_orgs: :environment do
    ContributingOrgValidator.validate
  end
end

class ContributingOrgValidator
  CLEAR = "\e[0m"
  RED = "\e[31m"
  GREEN = "\e[32m"
  ORG_FILE_PATH = Rails.root.join('config', 'organizations.yml')
  Data = Struct.new(:name, :source)

  class << self
    def validate = new.validate
  end

  def validate
    solr_orgs = fetch_orgs_from_solr
    scraped_orgs = parse_scraped_org_file
    print_diff(solr_orgs, scraped_orgs)
  end

  def print_diff(solr_orgs, scraped_orgs)
    only_in_solr = solr_orgs - scraped_orgs
    missing_from_solr = scraped_orgs - solr_orgs

    if only_in_solr.empty? && missing_from_solr.empty?
      puts '✅ Solr and Drupal are in harmony 🧘'
      return
    end

    only_in_solr.map! { |n| Data.new(n, :solr) }
    missing_from_solr.map! { |n| Data.new(n, :config) }

    orgs = (only_in_solr + missing_from_solr).sort_by(&:name)

    out = <<~DOC
      ❗️ Found differences between Solr (+) and Drupal (-) ❗️'
      Orgs in Solr that are missing from config/organizations.yml are in #{GREEN}green#{CLEAR}
      Orgs in config/organizations.yml that are missing from Solr are in #{RED}red#{CLEAR}
    DOC
    out = orgs.inject(out) do |acc, data|
      prefix = data.source == :solr ? "#{GREEN}+" : "#{RED}-"
      acc + "\n\t#{prefix} #{data.name}#{CLEAR}"
    end
    puts out
  end

  def parse_scraped_org_file
    YAML.load_file(ORG_FILE_PATH).keys
  end

  def fetch_orgs_from_solr
    response = client.connect.get('select', params: {
      'facet.field': 'contributing_organization_ssi',
      'facet.exists': true,
      'facet.limit': 500,
      'facet.method': 'enum',
      facet: true,
      fl: '*',
      qt: 'document',
      rows: 0,
      q: '*:*',
      wt: 'json'
    })

    orgs_in_solr = response.dig(
      'facet_counts',
      'facet_fields',
      'contributing_organization_ssi'
    ).select { |x| x.is_a?(String) }
  end

  def client = @client ||= SolrClient.new
end
