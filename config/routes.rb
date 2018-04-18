Rails.application.routes.draw do
resources :vuelos
root 'pages#home'
resources :predios
resources :materials
get '/signup', to: 'users#new'
resources :users, except: [:new]
  get 'login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
end
