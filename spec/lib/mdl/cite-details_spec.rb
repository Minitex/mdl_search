require 'rails_helper'
require_relative '../../../lib/mdl/cite_details.rb'

describe MDL::CiteDetails do
  let(:solr_doc) do
   JSON.parse(File.read(Rails.root.join('spec', 'fixtures', 'solr_doc.json')))
  end
  subject { MDL::CiteDetails.new(solr_doc: solr_doc) }
  describe 'when both a rights and a rights_uri field exist' do
    it 'ignores the rights field' do
      solr_doc_with_rights_uri = solr_doc.merge('rights_uri_ssi' => 'http://rights.org/blah')
      cite = MDL::CiteDetails.new(solr_doc: solr_doc_with_rights_uri)
      has_rights = cite.to_hash[:fields].any? { |field| field[:label] == 'Rights'}
      expect(has_rights).to eq false
    end
  end

  describe 'when a rights field exists but a rights_uri field does not exist' do
    it 'ignores includes the rights field' do
      solr_doc_with_rights_uri = solr_doc.merge('rights_uri_ssi' => 'http://rights.org/blah')
      cite = MDL::CiteDetails.new(solr_doc: solr_doc)
      has_rights = cite.to_hash[:fields].any? { |field| field[:label] == 'Rights'}
      expect(has_rights).to eq true
    end
  end
  describe "when transforming records" do
    it 'transforms the contributing organization field' do
      expect(subject.to_hash[:fields][0]).to eq({:label=>"Contributing Organization", :field_values=>[{:text=>"Minnesota Geological Survey", :url=>"/catalog?f[contributing_organization_ssi][]=Minnesota%20Geological%20Survey"}]})
    end


    it 'transforms the title field' do
      expect(subject.to_hash[:fields][1]).to eq({:label=>"Title", :field_values=>[{:text=>"Aeromagnetic map of Minnesota, central region, Plate 1"}]})
    end

    it 'transforms the creator field' do
      expect(subject.to_hash[:fields][2]).to eq({:label=>"Creator", :delimiter=>", ", :field_values=>[{:text=>"Chandler, Val W.", :url=>"/catalog?f[creator_ssim][]=Chandler,%20Val%20W."}]})
    end

    it 'transforms the creator field' do
      expect(subject.to_hash[:fields][3]).to eq({:label=>"Contributor", :delimiter=>", ", :field_values=>[{:text=>"Somebody", :url=>"/catalog?f[contributor_ssim][]=Somebody"}]})
    end

    it 'transforms the description field' do
      expect(subject.to_hash[:fields][4]).to eq({:label=>"Description", :field_values=>[{:text=>"Total magnetic intensity anomaly (relative to the earth's magnetic field), color coded, scale 1:250,000.  Interpretation of magnetic data collected from airborne surveys, the map colors indicate the distribution and concentration of magnetic minerals (primarily iron-bearing) within the upper crust of the earth. Electronic file available at: <a href=\"ftp://mgssun6.mngs.umn.edu/map_catalog/pdf/umn21100.pdf\">ftp://mgssun6.mngs.umn.edu/map_catalog/pdf/umn21100.pdf</a>"}]})
    end

    it 'transforms the date field' do
      expect(subject.to_hash[:fields][5]).to eq({:label=>"Date Created", :field_values=>[{:text=>"1985"}]})
    end

    it 'transforms the publishing agency field' do
      expect(subject.to_hash[:fields][6]).to eq({:label=>"Publishing Agency", :field_values=>[{:text=>"Minnesota Geological Survey", :url=>"/catalog?f[publishing_agency_ssi][]=Minnesota%20Geological%20Survey"}]})
    end

    it 'transforms the dimensions field' do
      expect(subject.to_hash[:fields][7]).to eq({:label=>"Dimensions", :field_values=>[{:text=>"64 x 93", :url=>"/catalog?f[dimensions_ssi][]=64%20x%2093"}]})
    end

    it 'transforms the topic field' do
      expect(subject.to_hash[:fields][8]).to eq({:label => "Minnesota Reflections Topic", :field_values=>[{:text=>"Environment", :url=>"/catalog?f[topic_ssim][]=Environment"}]})
    end

    it 'transforms the type field' do
      expect(subject.to_hash[:fields][9]).to eq({:label=>"Type", :field_values=>[{:text=>"Cartographic", :url=>"/catalog?f[type_ssi][]=Cartographic"}]})
    end

    it 'transforms the format field' do
      expect(subject.to_hash[:fields][10]).to eq({:label=>"Physical Format", :field_values=>[{:text=>"Maps", :url=>"/catalog?f[physical_format_ssi][]=Maps"}]})
    end

    it 'transforms the formal subject field' do
      expect(subject.to_hash[:fields][11]).to eq({:label=>"Library of Congress Subject Headings", :field_values=>[{:text=>"Geological Mapping", :url=>"/catalog?f[formal_subject_ssim][]=Geological%20Mapping"}, {:text=>"Geological Surveys", :url=>"/catalog?f[formal_subject_ssim][]=Geological%20Surveys"}, {:text=>"Geology Research", :url=>"/catalog?f[formal_subject_ssim][]=Geology%20Research"}]})
    end

    it 'transforms the keywords field' do
      expect(subject.to_hash[:fields][12]).to eq({:label=>"Keywords", :field_values=>[{:text=>"Aeromagnetics", :url=>"/catalog?f[subject_ssim][]=Aeromagnetics"}, {:text=>"Minnesota geology", :url=>"/catalog?f[subject_ssim][]=Minnesota%20geology"}]})
    end

    it 'transforms the city field' do
      expect(subject.to_hash[:fields][13]).to eq({:label=>"City or Township", :delimiter => ", ", :field_values =>[{:text=>"city of foo", :url=>"/catalog?f[city_ssim][]=city%20of%20foo"}]})
    end

    it 'transforms the county field' do
      expect(subject.to_hash[:fields][14]).to eq({:label=>"County", :delimiter => ", ", :field_values => [{:text=>"schmounty", :url=>"/catalog?f[county_ssim][]=schmounty"}]})
    end

    it 'transforms the state field' do
      expect(subject.to_hash[:fields][15]).to eq({:label=>"State or Province", :field_values=>[{:text=>"Minnesota", :url=>"/catalog?f[state_ssi][]=Minnesota"}]})
    end

    it 'transforms the country field' do
      expect(subject.to_hash[:fields][16]).to eq({:label=>"Country", :field_values => [{:text=>"United States", :url=>"/catalog?f[country_ssi][]=United%20States"}]})
    end

    it 'transforms the geographic feature field' do
      expect(subject.to_hash[:fields][17]).to eq({:label=>"Geographic Feature", :field_values => [{:text=>"mountain", :url=>"/catalog?f[geographic_feature_ssim][]=mountain"}]})
    end

    it 'transforms the geonames field' do
      expect(subject.to_hash[:fields][18]).to eq({:label=>"GeoNames URI", :field_values => [{:text=>"<a href=\"http://example.com\">http://example.com</a>", :url=>"/catalog?f[geonam_ssi][]=http://example.com"}]})
    end

    it 'transforms the language field' do
      expect(subject.to_hash[:fields][19]).to eq({:label=>"Language", :field_values=>[{:text=>"English"}]})
    end

    it 'transforms the local identifier field' do
      expect(subject.to_hash[:fields][20]).to eq({:label=>"Local Identifier", :field_values=>[{:text=>"a5 Pl1"}]})
    end

    it 'transforms the identifier field' do
      expect(subject.to_hash[:fields][21]).to eq({:label=>"MDL Identifier", :field_values => [{:text=>"umn96127"}]})
    end

    it 'transforms the fiscal sponsor field' do
      expect(subject.to_hash[:fields][22]).to eq({:label=>"Fiscal Sponsor", :field_values => [{:text=>"Mom and Dad"}]})
    end

    it 'transforms the parent collection field' do
      expect(subject.to_hash[:fields][23]).to eq({:label=>"Collection Name", :field_values => [{:text=>"collection here", :url=>"/catalog?f[parent_collection_name_ssi][]=collection%20here"}]})
    end

    it 'transforms the rights field' do
      expect(subject.to_hash[:fields][24]).to eq({:label=>"Rights", :field_values=>[{:text=>"Public domain.  We request that if the images are used credit be given to the Minnesota Geological Survey, University of Minnesota."}]})
    end

    it 'transforms the contact information field' do
      expect(subject.to_hash[:fields][25]).to eq({:label=>"Contact Information", :field_values=>[{:text=>"Minnesota Geological Survey, 2642 University Avenue, St. Paul, MN 55114"}]})
    end

    it 'transforms the fiscal sponsor field' do
      expect(subject.to_hash[:fields][26]).to eq({:label=>"Collection Description", :field_values=>[{:text=>"foo collection"}]})
    end
  end
end
