require 'net/http'
require 'nokogiri'

namespace :scrape do
  desc 'Scrape the links to contributing organizations'
  task :org_links do
    scraper = Scraper.new
    scraper.scrape
    File.open('config/organizations.yml', 'w+') do |f|
      result = scraper.orgs.to_h { |o| [o.name, o.href] }
      f << YAML.dump(result)
    end
  end
end

Org = Struct.new(:name, :href)

class Scraper
  attr_reader :orgs

  def initialize
    @orgs = []
  end

  def scrape
    page = 0
    doc = get_page(page)
    add_orgs(doc)
    while has_next?(doc)
      page += 1
      doc = get_page(page)
      add_orgs(doc)
    end
    puts "got #{orgs.size} orgs in all"
  end

  ###
  # @param doc [Nokogiri::HTML4::Document]
  # @return [void]
  def add_orgs(doc)
    page_orgs = parse_links(doc)
    puts "adding #{page_orgs.size} orgs"
    page_orgs.each do |org|
      self.orgs << org
    end
  end

  ###
  # @param page_num [Integer]
  # @return [Nokogiri::HTML4::Document]
  def get_page(page_num)
    puts "getting page #{page_num}"
    uri = URI::HTTPS.build(
      host: 'mndigital.org',
      path: '/about/contributing-organizations',
      query: "page=#{page_num}"
    )
    response = Net::HTTP.get_response(uri)
    raise unless response.code == '200'
    Nokogiri::HTML(response.body)
  end

  ###
  # @param doc [Nokogiri::HTML4::Document]
  # @return [Array<Org>]
  def parse_links(doc)
    doc.css('.field-content a').map do |anchor|
      Org.new(anchor.text, anchor['href'])
    end
  end

  ###
  # @param doc [Nokogiri::HTML4::Document]
  # @return [Boolean]
  def has_next?(doc) = !!doc.at_css('.page-link[rel=next]')
end
