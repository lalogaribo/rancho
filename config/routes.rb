Rails.application.routes.draw do
  root "pages#home"
  get '/index', to: 'pages#index'
  get '/signup', to: 'sessions#new_user'
  resources :users, except: [:new]
  get 'login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  resources :materials
  resources :nutrientes
  resources :info_predio
  resources :predios do
    resources :info_predio
    resources :charts
    resources :stats
    get "/new-users", to: "stats#new_users"
    get "/payments", to: "stats#payments"
    get "/sales", to: "stats#sales"
    get "/earnings", to: "stats#earnings"
  end
  resources :charts
  get "predios/:id/info", to: "info_predio#new", as: "info"
  get "/signup", to: "users#new"
  resources :vuelos
  resources :requests
end
