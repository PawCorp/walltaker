Rails.application.routes.draw do
  get 'notification/show'
  get 'porn_search/index'
  get 'porn_search/search'
  root 'dashboard#index'
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'session#new', as: 'login'
  get 'logout', to: 'session#destroy', as: 'logout'
  get 'browse', to: 'links#browse'
  get 'users/:username', to: 'users#show'
  get 'users/:username/edit', to: 'users#edit'
  get 'users/:username/history', to: 'past_links#index', as: 'past_links'
  get 'users/:username/status.json', to: 'users#status', as: 'user_status'
  get 'notifications/:id', to: 'notification#show', as: 'notification'
  resources :users
  resources :session
  resources :friendships do
    collection do
      get :requests, to: 'friendships#requests'
    end

    member do
      put :accept, to: 'friendships#accept'
    end
  end
  resources :links do
    member do
      get :walltaker, to: 'links#export'
    end
  end
  mount Blazer::Engine, at: "blazer"
end
