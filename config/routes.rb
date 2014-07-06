Myflix::Application.routes.draw do
  
  root to: 'main#front'

  # UI controller
  get 'ui(/:action)', controller: 'ui'

  # Main controller
  get 'home', to: 'main#home', as: :home

  # User
  get 'register', to: 'users#new', as: :register
  post 'register', to: 'users#create'

  # Videos
  resources :videos, only: :show do
    get 'search', to: 'videos#search', on: :collection
    resources :reviews, only: :create
  end

  # Session
  get 'sign-in', to: 'sessions#new', as: :sign_in
  post 'sign-in', to: 'sessions#create'
  delete 'sign-out', to: 'sessions#destroy', as: :sign_out

  # Categories
  resources :categories, only: :show
  
end
