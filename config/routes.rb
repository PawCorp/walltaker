Rails.application.routes.draw do
  root 'dashboard#index'
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'session#new', as: 'login'
  get 'logout', to: 'session#destroy', as: 'logout'
  get 'browse', to: 'links#browse'
  resources :users
  resources :session
  resources :links do
    member do
      get :walltaker, to: 'links#export'
    end
  end
end
