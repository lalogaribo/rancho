Rails.application.routes.draw do
<<<<<<< HEAD
  root "pages#home"
  resources :predios
  resources :materials
  get "/signup", to: "users#new"
  get "/charts", to: "charts#index"
  resources :users, except: [:new]
  get "login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  namespace :charts do
    get "new-users"
    get "new-materials"
    get 'invertido-materials'
  end
=======
resources :vuelos
resources :requests
root 'pages#home'
get '/index', to: 'pages#index'
resources :predios
resources :materials
get '/signup', to: 'users#new'
resources :users, except: [:new]
  get 'login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
>>>>>>> 865a47d70b035f8e678fa59a45927daeab195bb9
end
