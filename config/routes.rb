Rails.application.routes.draw do
root 'pages#home'
resources :predios
resources :materials
resources :nutrientes
get 'predios/:id/info', to: 'predios#informacion', as: 'info_predio'
get '/signup', to: 'users#new'
resources :users, except: [:new]
  get 'login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
end
