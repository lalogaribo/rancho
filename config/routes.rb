Rails.application.routes.draw do
  root "pages#home"
  get '/index', to: 'pages#index'
  get '/signup', to: 'users#new'
  resources :users, except: [:new]
  get 'login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  resources :materials
  resources :nutrientes
  resources :info_predio
  resources :predios do
    resources :info_predio
  end
  get "predios/:id/info", to: "info_predio#new", as: "info"
  get "/signup", to: "users#new"
  namespace :charts do
    get "new-users"
    get "new-materials"
    get 'invertido-materials'
  end
  get "/signup", to: "users#new"
  get "/charts", to: "charts#index"
  resources :vuelos
  resources :requests
end
