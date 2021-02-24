require 'spec_helper'
require_relative '../../../lib/mdl/etl_worker'

module MDL
  describe CompoundAggregatingTransformer do
    let(:field_mappings) do
      [
        {dest_path: 'id', origin_path: 'id', formatters: [CDMBL::StripFormatter, CDMBL::IDFormatter]},
        {dest_path: 'compound_objects_ts', origin_path: 'page', formatters: [CDMBL::ToJsonFormatter]},
        {dest_path: 'transcription_tesi', origin_path: 'transc', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'identifier_ssi', origin_path: 'resour', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'record_type', origin_path: 'record_type', formatters: []},
        {dest_path: 'parent_id', origin_path: 'parent_id', formatters: []},
        {dest_path: 'child_index', origin_path: 'child_index', formatters: []}
      ]
    end

    describe 'aggregating transcriptions of compound documents' do
      context 'when extract_compounds is unset' do
        it "aggregates the transcriptions of the child pages onto the parent record" do
          records = [{
            'id' => 'foo/5123',
            'page' => [{'id' => 'blah/3245', 'transc' => 'OHAI CHEEZEBURGER'}]
          }]
          transformation = CompoundAggregatingTransformer.new(cdm_records: records, field_mappings: field_mappings).records
          expect(transformation).to eq([
            {
              "id"=>"foo:5123",
              "transcription_tesim"=>["OHAI CHEEZEBURGER"],
              "compound_objects_ts"=>"[{\"id\":\"blah/3245\",\"transc\":\"OHAI CHEEZEBURGER\"}]","record_type"=>"primary"
            }
          ])
        end

        context 'when there is no transcription page' do
          it 'does not represent a transcription' do
            records = [{
              'id' => 'foo/5123',
              'page' => [{'id' => 'blah/3245'}]
            }]
            transformation = CompoundAggregatingTransformer.new(cdm_records: records, field_mappings: field_mappings).records
            expect(transformation).to eq([
              {
                "id"=>"foo:5123",
                "compound_objects_ts"=>"[{\"id\":\"blah/3245\"}]","record_type"=>"primary"
              }
            ])
          end
        end
      end

      context 'when extract_compounds is set to true (we want to unpack the compounds)' do
        it "aggregates the transcriptions onto the parent and creates child documents" do
          records = [{
            'id' => 'foo/5123',
            'page' => [
              {'id' => 'blah/3245', 'transc' => 'OHAI CHEEZEBURGER'},
              {'id' => 'blah/3248', 'transc' => 'OHAI CHEEZEBURGER 1'}
            ]
          }]
          transformation = CompoundAggregatingTransformer.new(cdm_records: records, extract_compounds: true, field_mappings: field_mappings).records
          expect(transformation).to eq([
            {"id"=>"foo:5123", "transcription_tesim"=>["OHAI CHEEZEBURGER", "OHAI CHEEZEBURGER 1"], "compound_objects_ts"=>"[{\"id\":\"blah/3245\",\"transc\":\"OHAI CHEEZEBURGER\",\"parent_id\":\"foo/5123\",\"parent\":{\"id\":\"foo/5123\",\"record_type\":\"primary\"},\"record_type\":\"secondary\",\"child_index\":0},{\"id\":\"blah/3248\",\"transc\":\"OHAI CHEEZEBURGER 1\",\"parent_id\":\"foo/5123\",\"parent\":{\"id\":\"foo/5123\",\"record_type\":\"primary\"},\"record_type\":\"secondary\",\"child_index\":1}]", "record_type"=>"primary"},
            {"id"=>"blah:3245", "transcription_tesi"=>"OHAI CHEEZEBURGER", "record_type"=>"secondary", "parent_id"=>"foo/5123", "child_index"=>0},
            {"id"=>"blah:3248", "transcription_tesi"=>"OHAI CHEEZEBURGER 1", "record_type"=>"secondary", "parent_id"=>"foo/5123", "child_index"=>1}
          ])
        end
      end
    end

    describe 'aggregating MDL Identifiers of compound documents' do
      it "aggregates the MDL Identifiers of the child pages onto the parent record" do
        records = [{
          'id' => 'foo/5123',
          'page' => [
            {'id' => 'blah/3245', 'resour' => 'fakeID'},
            {'id' => 'blah/3246', 'resour' => 'realID'},
          ]
        }]
        transformation = CompoundAggregatingTransformer.new(
          cdm_records: records,
          field_mappings: field_mappings
        ).records
        expect(transformation).to eq([
          {
            "id"=>"foo:5123",
            "identifier_ssim"=>["fakeID", "realID"],
            "compound_objects_ts"=>"[{\"id\":\"blah/3245\",\"resour\":\"fakeID\"},{\"id\":\"blah/3246\",\"resour\":\"realID\"}]",
            "record_type"=>"primary"
          }
        ])
      end
    end
  end
end
