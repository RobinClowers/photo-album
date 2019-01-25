Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :omniauth_callbacks => "users/omniauth_callbacks",
    :registrations => "users/registrations",
    :sessions => "users/sessions",
    :confirmations => "users/confirmations",
    :passwords => "users/passwords",
  }
  root 'albums#index'
  get '/albums', to: redirect('/')
  get '/users/current' => 'current_user#show', as: 'current_user'

  resources :albums, only: [:show] do
    resources :photos, only: [:show], controller: 'albums/photos'
  end

  resources :photos, only: [] do
    resources :plus_ones, only: [:create, :destroy], controller: 'photos/plus_ones'
    resources :comments, only: [:create, :destroy], controller: 'photos/comments'
  end
  namespace :photos do
    resources :favorites, only: [:index]
  end
  namespace :admin do
    root 'albums#index'
    post 'error' => 'albums#error', as: 'test_error'
    resources :albums, only: [:new, :create, :update]
    resources :process_all_albums_jobs, only: [:create]
    resources :process_album_jobs, only: [:create]
    resources :process_version_jobs, only: [:create]
    resources :publish_album_jobs, only: [:create]
    resources :photos, only: [:update]
    resources :google_photos_albums, only: [:index, :create]

    # Google Photos oauth
    get "/google_photos_authorizations/new" => "google_photos_authorizations#new", as: :new_google_photos_authorization
    get "/google_photos_authorizations/callback" => "google_photos_authorizations#create"
  end

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web, at: "/sidekiq"
  end
end
