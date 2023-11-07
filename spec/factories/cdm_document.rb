FactoryBot.define do
  factory :cdm_document, class: Hash do
    skip_create

    transient do
      fixture { 'multipage_text.yml' }
    end

    trait :audio do
      fixture { 'audio.yml' }
    end

    trait :audio_playlist do
      fixture { 'audio_playlist.yml' }
    end

    trait :video do
      fixture { 'video.yml' }
    end

    trait :video_playlist do
      fixture { 'video_playlist.yml' }
    end

    trait :multipage_text do
      fixture { 'multipage_text.yml' }
    end

    trait :image do
      fixture { 'image_with_transc.yml' }
    end

    initialize_with do
      filepath = File.expand_path(
        File.join('..', '..', 'fixtures', 'contentdm', fixture),
        __FILE__
      )
      YAML.load_file(filepath)
    end
  end
end
