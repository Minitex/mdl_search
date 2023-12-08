FactoryBot.define do
  factory :cdm_iiif_manifest, class: Hash do
    skip_create

    transient do
      fixture { 'mhd:6801.json' }
    end

    initialize_with do
      filepath = File.expand_path(
        File.join('..', '..', 'fixtures', 'contentdm', 'iiif_manifest', fixture),
        __FILE__
      )
      IO.read(filepath)
    end
  end
end
