PhotoAlbum::Application.routes.draw do
  root 'root#index'

  resources :albums, only: [:index, :show]
end
