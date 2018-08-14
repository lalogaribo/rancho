Rails.application.routes.draw do
  resources :workers
  root 'pages#home'
  get '/index', to: 'pages#index'
  get '/signup', to: 'sessions#new_user'
  resources :users, except: [:new]
  get 'login', to: 'sessions#new'
  get '/:token/confirm_email/', to: 'users#confirm_email', as: 'confirm_email'
  post '/login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  resources :materials
  resources :nutrientes
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
  resources :charts
  get 'predios/:id/info', to: 'info_predio#new', as: 'info'
  get '/signup', to: 'users#new'
  resources :vuelos
  resources :requests
  match '*unmatched', to: 'application#route_not_found', via: :all
end
