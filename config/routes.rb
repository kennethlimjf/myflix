Myflix::Application.routes.draw do
  
  root to: 'main#front'

  # UI controller
  get 'ui(/:action)', controller: 'ui'

  # Main controller
  get 'home', to: 'main#home', as: :home

  # User
  get 'register(/:token)', to: 'users#new', as: :register
  post 'register', to: 'users#create'
  resources :users, only: :show
  get 'forgot-password', to: 'users#forgot_password', as: :forgot_password
  post 'forgot-password', to: 'users#forgot_password_submit'
  get 'reset-password', to: 'users#reset_password', as: :reset_password
  patch 'reset-password', to: 'users#reset_password_submit'

  # Videos
  resources :videos, only: :show do
    get 'search', to: 'videos#search', on: :collection
    resources :reviews, only: :create
  end

  # Queue Items
  get 'my-queue', to: 'queue_items#index', as: :my_queue
  resources :queue_items, only: [:destroy, :create]
  patch 'update-queue', to: 'queue_items#update_queue_items', as: :update_queue_items

  # Session
  get 'sign-in', to: 'sessions#new', as: :sign_in
  post 'sign-in', to: 'sessions#create'
  delete 'sign-out', to: 'sessions#destroy', as: :sign_out

  # Categories
  resources :categories, only: :show

  # Follows
  get 'people', to: 'follows#index', as: :people
  resources :follows, only: [:create, :destroy]
  
  # Invites
  resources :invitations, only: [:new, :create]

  # Expired token path
  get 'expired-token', to: 'application#expired_token', as: :expired_token

  # Admin
  namespace :admin do
    resources :videos, only: [:new, :create]
    resources :payments, only: :index
  end

  # Payments
  mount StripeEvent::Engine => '/stripe-events'
  
end
