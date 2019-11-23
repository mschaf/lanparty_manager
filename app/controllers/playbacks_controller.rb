class PlaybacksController < ApplicationController

  skip_before_action :verify_authenticity_token
  before_action :check_token, only: [:show, :create, :destroy, :update]
  power :playback, map: { [:pause, :resume, :skip] => :controllable_playback }

  def show
    load_playback
    respond_to do |format|
      format.json do
        if @playback
          render json: @playback.as_json(include: :song), response_code: 200
        else
          render json: { state: 'not playing' }, response_code: 204
        end
      end
    end
  end

  def create
    load_playback
    build_playback
    respond_to do |format|
      format.json do
        begin
          if save_playback
            render json: @playback.as_json(include: :song), response_code: 201
          else
            render json: { error: @playback.errors.messages.map{ |key, message| message }.join(', ') }, response_code: 400
          end
        rescue Song::Playback::BackgroundPlaylistNotFound
          render json: { error: 'background playlist was not found' }, response_code: 500
        end
      end
    end
  end

  def destroy
    load_playback
    respond_to do |format|
      format.json do
        if @playback
          if @playback.destroy
            render json: {}, response_code: 200
          else
            render json: { error: current_playing.errors.messages.map{ |key, message| message }.join(', ') }, response_code: 400
          end
        else
          render json: { error: 'nothing was playing' }, response_code: 204
        end
      end
    end
  end

  def update
    load_playback
    @playback.attributes = playback_params
    respond_to do |format|
      format.json do
        if save_playback
          render json: @playback.as_json(include: :song), response_code: 200
        else
          render json: { error: @playback.errors.messages.map{ |key, message| message }.join(', ') }, response_code: 400
        end
      end
    end
  end

  def pause
    load_playback
    unless @playback.pause
      flash[:error] = "Pause failed #{@playback.errors.messages.map{ |key, message| message }.join(', ')}"
    end
    redirect_to songs_path
  end

  def resume
    load_playback
    unless @playback.resume
      flash[:error] = "Resume failed #{@playback.errors.messages.map{ |key, message| message }.join(', ')}"
    end
    redirect_to songs_path
  end

  def skip
    load_playback
    unless @playback.skip
      flash[:error] = "Skip failed #{@playback.errors.messages.map{ |key, message| message }.join(', ')}"
    end
    redirect_to songs_path
  end

  private

  def playback_params
    playback_params = params[:playback]
    playback_params ? playback_params.permit(:current_time) : {}
  end


  def build_playback
    @playback = Song::Playback.new
  end

  def load_playback
    @playback = Song::Playback.first
  end

  def save_playback
    @playback.save
  end

  def check_token
    unless params[:token].present? && params[:token] == Rails.application.credentials.api_token
      render json: { error: 'invalid token' }, response_code: 401
    end
  end
end
