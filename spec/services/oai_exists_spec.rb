require 'rails_helper'

describe OaiExists, type: :service do
  describe "When a record does not exist" do
    it "indicates that it does not exist" do
      VCR.use_cassette('oai-exists/not-exists') do
        instance = OaiExists.new(collection: 'fakiefaker', id: 'nuttin')
        expect(instance.exists?).to be true
      end
    end
  end

  describe "When a record exists" do
    it "indicates that it does exist" do
      VCR.use_cassette('oai-exists/exists') do
        instance = OaiExists.new(collection: 'p16022coll44', id: '1')
        expect(instance.exists?).to be false
      end
    end
  end
end
