class Power
  include Consul::Power

  def initialize(user)
    @user = user
  end

  def admin?
    @user&.admin?
  end

  power :games do
    Game.all
  end

  power :creatable_games, :updatable_games, :destroyable_games do
    games if admin?
  end

  power :songs do
    if admin?
      Song.all
    else
      Song.where(state: [Song::STATE_QUEUE, Song::STATE_PLAYING])
    end
  end

  power :creatable_songs do
    if admin?
      songs
    else
      if @user && Song.where(user_id: @user.id, state: Song::STATE_QUEUE).count <= 2
        songs
      end
    end
  end

  power :can_queue_long_songs do
    admin?
  end

  power :can_queue_over_limit do
    admin?
  end

  power :can_queue_while_locked do
    admin?
  end

  power :updatable_songs, :destroyable_songs do
    if admin?
      songs.where(state: Song::STATE_QUEUE)
    end
  end

  power :permittable_song_params do
    if admin?
      [:song_id, :queue_position]
    else
      [:song_id]
    end
  end

  power :playback do
    Song::Playback.all
  end

  power :creatable_playback, :updatable_playback, :destroyable_playback do
    nil
  end

  power :controllable_playback do
    if admin?
      playback
    end
  end

  power :users do
    User.all if admin?
  end

  power :creatable_users do
    unless @user || Setting.get_or_initialize.lock_sign_up
      User.all
    end
  end

  power :updatable_users, :destroyable_users do
    users if admin?
  end

  power :permittable_user_params do
    if @user.nil?
      [:name, :password, :password_confirmation]
    elsif admin?
      [:name, :display_name, :password, :password_confirmation, :admin, :locked]
    end
  end

  power :settings do
    Setting.all if admin?
  end

  power :updatable_settings do
    Setting.all if admin?
  end

end
