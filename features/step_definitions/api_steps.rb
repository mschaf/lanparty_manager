Given /the apis are stubbed/ do
  step 'the spotify api is stubbed'
  step 'the youtube api is stubbed'
end

Given /the spotify api is stubbed/ do
  song1 = build(:spotify_song, title: 'Master of Puppets', artist: 'Metallica', album: 'Master of Puppets', duration: (8 * 60 + 37) * 1000)
  song2 = build(:spotify_song, title: 'Enter Sandman', artist: 'Metallica', album: 'Metallica', duration: (5 * 60 + 31) * 1000)

  allow(Song::Spotify::Api).to receive(:search).and_return([song1, song2])

  allow(Song::Spotify::Api).to receive(:find_attributes_by_id).with(song1.song_id).and_return({
                                                                                                  title: song1.title,
                                                                                                  album: song1.album,
                                                                                                  artist: song1.artist,
                                                                                                  duration: song1.duration,
                                                                                                  cover_url: "file://#{Rails.root}/spec/support/sample_files/sample_cover_image.jpg",
                                                                                              })
  allow(Song::Spotify::Api).to receive(:find_attributes_by_id).with(song2.song_id).and_return({
                                                                                                  title: song2.title,
                                                                                                  album: song2.album,
                                                                                                  artist: song2.artist,
                                                                                                  duration: song2.duration,
                                                                                                  cover_url: 'spec/support/sample_files/sample_cover_image.jpg',
                                                                                              })
end

Given /the youtube api is stubbed/ do
  song1 = build(:youtube_song, title: 'Ivan B - Sweaters', artist: 'BestModernMusic', duration: (2 * 60 + 28) * 1000)
  song2 = build(:youtube_song, title: 'FiNCH ASOZiAL - ABFAHRT', artist: 'Finch Asozial', duration: (4 * 60 + 02) * 1000)

  allow(Song::Youtube::Api).to receive(:search).and_return([song1, song2])

  allow(Song::Youtube::Api).to receive(:find_attributes_by_id).with(song1.song_id).and_return({
                                                                                                  title: song1.title,
                                                                                                  album: song1.album,
                                                                                                  artist: song1.artist,
                                                                                                  duration: song1.duration,
                                                                                                  cover_url: 'spec/support/sample_files/sample_cover_image.jpg',
                                                                                              })
  allow(Song::Youtube::Api).to receive(:find_attributes_by_id).with(song2.song_id).and_return({
                                                                                                  title: song2.title,
                                                                                                  album: song2.album,
                                                                                                  artist: song2.artist,
                                                                                                  duration: song2.duration,
                                                                                                  cover_url: 'spec/support/sample_files/sample_cover_image.jpg',
                                                                                              })
end
