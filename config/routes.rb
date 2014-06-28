Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get 'home', to: 'main#home'
  resources :videos, only: :show do
    get 'search', to: 'videos#search', on: :collection
  end
  resources :categories, only: :show
end
