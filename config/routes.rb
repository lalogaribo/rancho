Rails.application.routes.draw do

  root "pages#home"
  resources :materials
  resources :nutrientes
  resources :info_predio
  resources :predios do
    resources :info_predio
  end
  get "predios/:id/info", to: "info_predio#new", as: "info"
  get "/signup", to: "users#new"
  resources :users, except: [:new]
  get "login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  resources :vuelos
  resources :requests
  get '/index', to: 'pages#index'
end
