require 'sidekiq/web'

PhotoAlbum::Application.routes.draw do
  root 'albums#index'
  get '/albums', to: redirect('/')

  get "/auth/:provider/callback" => "sessions#create"
  delete "/signout" => "sessions#destroy", :as => :signout

  resources :albums, only: [:show]

  mount Sidekiq::Web, at: "/sidekiq"
end
