Rails.application.routes.draw do
root 'pages#home'
get '/index', to: 'pages#index'
resources :predios
resources :materials
get '/signup', to: 'users#new'
resources :users, except: [:new]
  get 'login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
end
