Rails.application.routes.draw do
  root 'pages#home'
  resources :predios
  resources :materials
  get '/signup', to: 'users#new'
  get '/charts', to: 'charts#index'
  resources :users, except: [:new]
  get 'login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  namespace :charts do
    get 'new-users'
  end
end
