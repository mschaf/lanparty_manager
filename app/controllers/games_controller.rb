class GamesController < ApplicationController

  power crud: :games, as: :game_scope

  def index
    load_games
  end

  def new
    build_game
  end

  def create
    build_game
    save_game or render 'new'
  end

  def edit
    load_game
    build_game
  end

  def update
    load_game
    build_game
    save_game or render 'edit'
  end

  def destroy
    load_game
    @game.destroy
    redirect_to games_path
  end

  private

  def load_games
    @games ||= game_scope.order(:name).to_a
  end

  def load_game
    @game ||= game_scope.find(params[:id])
  end

  def build_game
    @game ||= game_scope.build
    @game.attributes = game_params
  end

  def save_game
    if @game.save
      redirect_to games_path
    end
  end

  def game_params
    game_params = params[:game]
    game_params ? game_params.permit(:name, :description, :cover_image, :remove_cover_image) : {}
  end


end
