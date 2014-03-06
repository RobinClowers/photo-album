PhotoAlbum::Application.routes.draw do
  root 'albums#index'

  get "/auth/:provider/callback" => "sessions#create"
  delete "/signout" => "sessions#destroy", :as => :signout

  resources :albums, only: [:show]
end
