Rails.application.routes.draw do
  get 'pages/top'
  root to: 'pages#top'
  #get 'posts/new', to: 'posts#new'
  #post 'posts/create', to: 'posts#create'
  #get 'posts/edit/:id', to: 'posts#edit'
  #post 'posts/update/:id', to: 'posts#update'
  resources :posts 
 
  #mount Shrine.presign_endpoint(:cache) => "/s3/params"
  mount Shrine.upload_endpoint(:cache) => "/upload"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
