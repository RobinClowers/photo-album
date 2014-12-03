require 'sidekiq/web'

PhotoAlbum::Application.routes.draw do
  root 'albums#index'
  get '/albums', to: redirect('/')

  get "/auth/:provider/callback" => "sessions#create"
  delete "/signout" => "sessions#destroy", :as => :signout

  resources :albums, only: [:show]
  resources :photos do
    resources :plus_ones, only: [:create, :destroy], controller: 'photos/plus_ones'
  end
  namespace :admin do
    root 'albums#index'
    resources :albums, only: [:new, :create]
    resources :process_album_jobs, only: [:create]
    resources :publish_album_jobs, only: [:create]
    resources :photos, only: [:update]
  end

  mount Sidekiq::Web, at: "/sidekiq"
end
