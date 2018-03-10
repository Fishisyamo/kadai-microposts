Rails.application.routes.draw do
  root to: 'toppages#index'

  get    'login',  to: 'sessions#new'
  post   'login',  to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get    'signup', to: 'users#new'
  post   'signup', to: 'users#create'

  # resources
  resources :users, only: [:index, :show] do
    member do
      get :followings, :followers, :favoring
    end
  end

  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :favorites,     only: [:create, :destroy]
end