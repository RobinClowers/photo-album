require 'sidekiq/web'

Rails.application.routes.draw do
  root 'albums#index'
  get '/albums', to: redirect('/')

  get "/auth/:provider/callback" => "sessions#create"
  delete "/signout" => "sessions#destroy", :as => :signout

  resources :albums, only: [:show]
  get 'albums/:id/:photo', to: 'albums#show', as: :photo

  resources :photos, only: [] do
    resources :plus_ones, only: [:index, :create, :destroy], controller: 'photos/plus_ones'
    resources :comments, only: [:index, :create, :destroy], controller: 'photos/comments'
  end
  namespace :admin do
    root 'albums#index'
    get 'error' => 'albums#error', as: 'test_error'
    resources :albums, only: [:new, :create, :update]
    resources :process_album_jobs, only: [:create]
    resources :process_version_jobs, only: [:create]
    resources :publish_album_jobs, only: [:create]
    resources :photos, only: [:edit, :update]
    resources :google_photos_albums, only: [:index, :create]

    # Google Photos oauth
    get "/google_photos_authorizations/new" => "google_photos_authorizations#new", as: :new_google_photos_authorization
    get "/google_photos_authorizations/callback" => "google_photos_authorizations#create"
  end

  mount Sidekiq::Web, at: "/sidekiq", constraints: AdminConstraint.new
end
