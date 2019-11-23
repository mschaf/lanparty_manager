class SettingsController < ApplicationController

  power crud: :settings, as: :settings_scope

  def edit
    load_setting
    build_setting
  end

  def update
    load_setting
    build_setting
    if save_setting
      flash.now[:success] = 'Settings updated'
    else
      flash.now[:danger] = 'Error'
    end
    render 'edit'
  end

  private

  def load_setting
    @setting = Setting.get_or_initialize
  end

  def build_setting
    @setting.attributes = setting_params
  end

  def save_setting
    @setting.save
  end

  def setting_params
    setting_params = params[:setting]
    setting_params ? setting_params.permit([:lock_sign_up, :lock_queue, :max_songs_queued_at_once, :games_top_text, :background_playlist_user, :background_playlist]) : {}
  end

end
