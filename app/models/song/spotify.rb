class Song::Spotify < Song

  def set_attributes_form_api
    if init_from_api
      self.attributes = Api.find_attributes_by_id(self.song_id)
    end
  end

  def type_as_string
    'spotify'
  end

end
