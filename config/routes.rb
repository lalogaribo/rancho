Rails.application.routes.draw do
  root 'pages#home'
  get '/index', to: 'pages#index'
  get '/signup', to: 'sessions#new_user'
  get 'login', to: 'sessions#new'
  get '/:token/confirm_email/', to: 'users#confirm_email', as: 'confirm_email'
  post '/login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :users, except: [:new]
  resources :workers
  resources :materials
  resources :nutrientes
  resources :charts
  resources :vuelos
  resources :requests
  resources :info_predio
  resources :predios do
    resources :info_predio
    resources :charts
    resources :stats
    get '/new-users', to: 'stats#new_users'
    get '/investment', to: 'stats#investment'
    get '/sales', to: 'stats#sales'
    get '/earnings', to: 'stats#earnings'
    get '/materials', to: 'stats#materials'
    get '/investment/month', to: 'stats#investmentByMonth'
    get '/sales/month', to: 'stats#salesByMonth'
    get '/materials/month', to: 'stats#materialsByMonth'
    get '/earnings/month', to: 'stats#earningsByMonth'
    get '/investment/year', to: 'stats#investmentByYear'
    get '/sales/year', to: 'stats#salesByYear'
    get '/materials/year', to: 'stats#materialsByYear'
    get '/earnings/year', to: 'stats#earningsByYear'
  end
  get 'predios/:id/info', to: 'info_predio#new', as: 'info'
  get '/signup', to: 'users#new'
  match '*unmatched', to: 'application#route_not_found', via: :all
end
