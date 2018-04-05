Rails.application.routes.draw do
root 'pages#home'
resources :predios
resources :materials
resources :nutrientes
resources :info_predio
get 'predios/:id/info', to: 'info_predio#new', as: 'info'
get '/signup', to: 'users#new'
resources :users, except: [:new]
  get 'login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
end
