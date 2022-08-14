FactoryGirl.define do
  factory :borealis_document, class: MDL::BorealisDocument do
    transient do
      fixture_filename { 'video.json' }
    end
    initialize_with do
      document = JSON.parse(
        IO.read(
          Rails.root.join(
            'spec',
            'fixtures',
            'solr',
            fixture_filename
          )
        )
      )
      MDL::BorealisDocument.new(document: document)
    end

    trait :image do
      transient do
        fixture_filename { 'image.json' }
      end
    end

    trait :video do
      transient do
        fixture_filename { 'video.json' }
      end
    end

    trait :video_playlist do
      transient do
        fixture_filename { 'video_playlist.json' }
      end
    end

    trait :audio do
      transient do
        fixture_filename { 'audio.json' }
      end
    end

    trait :audio_playlist do
      transient do
        fixture_filename { 'audio_playlist.json' }
      end
    end
  end
end
