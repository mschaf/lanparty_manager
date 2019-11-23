class Song::Youtube::Api

  def self.search(query, limit)
    search_scraper(query, limit)
    #search_api(query, limit)
  end

  def self.find_attributes_by_id(id)
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = api_key

    begin
      search_response = service.list_videos('snippet, contentDetails', id: id)
    rescue Google::Apis::ClientError
      return {}
    end

    video = search_response.items.first
    {
      song_id: video.id,
      title: video.snippet.title,
      artist: video.snippet.channel_title,
      cover_url: video.snippet.thumbnails.default.url,
      duration: ActiveSupport::Duration.parse(video.content_details.duration).in_milliseconds
    }
  end

  # scraping the plain html return for the youtube search gives us up to 24 results and even more metadata than the search api
  def self.search_scraper(query, limit)
    doc = Nokogiri::HTML(open("https://www.youtube.com/results?search_query=#{CGI.escape(query)}"))
    video_list = doc.css('ol.item-section').first
    songs = []
    video_list.css('> li').each do |video|
      begin
        title_link = video.css('h3.yt-lockup-title > a.yt-uix-tile-link').first
        title = title_link.text
        /\A\/watch\?v=(?<video_id>[a-zA-Z0-9_-]{11})/ =~ title_link['href']
        /((?<hours>\d+):)?(?<minutes>\d+):(?<seconds>\d+)\z/ =~ video.css('h3.yt-lockup-title > span.accessible-description').first.text
        raise unless minutes.present? && seconds.present?
        duration = (hours.to_i * 60 * 60 + minutes.to_i * 60 + seconds.to_i) * 1000
        channel = video.css('.yt-lockup-content > .yt-lockup-byline').first.text
        cover_url = "https://i.ytimg.com/vi/#{video_id}/mqdefault.jpg"
        songs << Song::Youtube.new(song_id: video_id, title: title, artist: channel, duration: duration, cover_url: cover_url)
      rescue
      end
    end
    limit = [limit, songs.length].min
    songs.first(limit)
  end


  # for search only really usable with increased quota
  def self.search_api(query, limit)
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = api_key

    # refrence: https://developers.google.com/youtube/v3/docs/search/list
    begin
      search_response = service.list_searches('snippet',
                                              q: query,
                                              max_results: limit,
                                              safe_search: 'none',
                                              type: 'video',
                                              )
    rescue Google::Apis::ClientError
      return []
    end


    songs = search_response.items.map do |video|
      Song::Youtube.new(song_id: video.id.video_id,
                        title: video.snippet.title,
                        artist: video.snippet.channel_title,
                        cover_url: video.snippet.thumbnails.default.url,
                        )
    end
    songs
  end

  # allow to define multiple api keys to get around the pathetic api quota of 100 searches a day
  def self.api_key
    keys = [Rails.application.credentials.youtube_api_key]
    (1..10).each do |i|
      method = "youtube_api_key#{i}".to_sym
      if Rails.application.credentials.methods.include?(method)
        keys << Rails.application.credentials.public_send(method)
      end
    end
    keys[rand(keys.length)]
  end

end
