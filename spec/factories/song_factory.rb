FactoryBot.define do
  factory :spotify_song, class: Song::Spotify do
    title { 'Example Song' }
    artist { 'Example Artist' }
    album { 'Example Album' }
    duration { 180000 }

    cover_image { Rack::Test::UploadedFile.new(Rails.root.join('spec/support/sample_files/sample_song_cover.jpg'), 'image/jpeg')  }

    sequence(:song_id, 'a') { |n| n * 22 }

  end

  factory :youtube_song, class: Song::Youtube do
    title { 'Example Song' }
    artist { 'Example Artist' }

    duration { 180000 }

    cover_image { Rack::Test::UploadedFile.new(Rails.root.join('spec/support/sample_files/sample_song_cover.jpg'), 'image/jpeg')  }

    sequence(:song_id, 'a') { |n| n * 11 }

  end
end

