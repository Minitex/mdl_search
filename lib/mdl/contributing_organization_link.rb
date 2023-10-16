module MDL
  module ContributingOrganizationLink
    LINKS_BY_NAME = YAML
      .load_file(Rails.root.join('config', 'organizations.yml'))
      .freeze

    def self.resolve(org_name)
      path = LINKS_BY_NAME.fetch(org_name) { return }
      URI::HTTPS.build(host: 'mndigital.org', path:).to_s
    end
  end
end
