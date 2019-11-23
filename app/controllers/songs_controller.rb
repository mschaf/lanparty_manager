class SongsController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [ :index ]
  power crud: :songs, as: :song_scope

  def index
    load_songs
    respond_to do |format|
      format.html
      format.json do
        json = @songs.map{|song| song.attributes.merge({type: song.type_as_string })}.as_json
        render json: json
      end
    end
  end

  def create
    build_song
    @song.init_from_api = true
    @song.state = Song::STATE_QUEUE
    @song.user = current_user
    unless save_song
      flash[:danger] = "Error: #{@song.errors.messages.map{ |key, message| message }.join(', ')}"
    end
    redirect_to songs_path
  end

  def destroy
    load_song
    @song.destroy
    redirect_to songs_path
  end

  def search
    @query = params[:query]
    @search_songs_youtube = Song::Youtube::Api.search(@query, 5) if @query.length >= 3
    @search_songs_spotify = Song::Spotify::Api.search(@query, 5) if @query.length >= 3
    load_songs
    render 'index'
  end

  private

  def load_songs
    @songs ||= song_scope.order(:created_at)
  end

  def load_song
    @song ||= song_scope.find(params[:id])
  end

  def build_song
    if params[:type] == 'spotify'
      @song ||= Song::Spotify.new
    elsif params[:type] == 'youtube'
      @song ||= Song::Youtube.new
    else
      @song ||= song_scope.build
    end
    @song.attributes = song_params
  end

  def save_song
    @song.save
  end

  def song_params
    song_params = params[:song]
    song_params ? song_params.permit(*current_power.permittable_song_params) : {}
  end

end
