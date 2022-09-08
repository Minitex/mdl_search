FactoryBot.define do
  factory :cdm_document, class: OpenStruct do
    id { 'mpls:13128' }
    original_file_uri { 'http://cdm16022.contentdm.oclc.org/utils/getfile/collection/mpls/id/13128/filename/mpls-13128' }
    format { 'image/jp2' }

    trait :with_compound_objects do
      compound_objects { [{pagefile: '13096.jp2', pageptr: '13096', pagetitle: 'Front Cover'}] }
    end
  end
end
