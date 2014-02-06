PhotoAlbum::Application.routes.draw do
  root 'albums#index'

  resources :albums, only: [:show]
end
