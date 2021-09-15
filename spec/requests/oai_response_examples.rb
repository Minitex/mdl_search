shared_examples 'OAI responses' do |args|
  it 'returns a valid OAI resposne' do
    verb = args.fetch(:verb)

    parsed = Nokogiri::XML(response.body)

    errors = []
    xsd = Nokogiri::XML::Schema(File.read('spec/fixtures/oai/OAI-PMH.xsd'))
    xsd.validate(parsed) do |error|
      errors << error.message
    end
    expect(errors).to be_empty

    response_date = Time.zone.parse(parsed.xpath('//xmlns:OAI-PMH/xmlns:responseDate').text)
    expect(response_date).to be_today

    expect(parsed.xpath('//xmlns:OAI-PMH/xmlns:request/@verb').text).to eq verb
    expect(parsed.xpath('//xmlns:OAI-PMH/xmlns:request').text).to eq 'https://reflections.mndigital.org/catalog/oai'
  end
end
