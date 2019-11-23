Rails.application.routes.draw do

  get '/test' => 'static_pages#test'

  root 'games#index'

  get '/signin' => 'sessions#new'
  post '/signin' => 'sessions#create'
  delete '/signin' => 'sessions#destroy'

  resources :games, except: [:show]
  resources :songs, except: [:show] do
    collection do
      get :search
    end
  end

  resource :playback do
    post :pause
    post :resume
    post :skip
  end

  resources :users
  resource :settings, only: [:edit, :update]

end
