Rails.application.routes.draw do
  mount Nuttracker::Engine => "/nut"
  get 'help', to: 'help#index', as: 'help'
  get 'leaderboard', to: 'leaderboard#index', as: 'leaderboard'
  get 'notification/show'
  delete 'notification', to: 'notification#delete_all', as: 'clear_notifications'
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
  post 'users/:username/key', to: 'users#new_api_key', as: 'user_new_api_key'
  get 'notifications/:id', to: 'notification#show', as: 'notification'

  defaults format: :json do
    get 'api/links/:id.json', to: 'api#show_link'
    post 'api/links/:id/response.json', to: 'api#set_link_response'
    get 'api/users/:username.json', to: 'api#show_user', as: 'user_status'
  end

  resources :users
  resources :session
  resources :message_thread, path: 'messages' do
    member do
      post :send, to: 'message_thread#send_message', as: 'send_to'
      post 'users/:user_id', to: 'message_thread#add_user', as: 'add_user'
      delete 'users/:user_id', to: 'message_thread#remove_user', as: 'remove_user'
    end
  end
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
    resources :comments
  end
  mount Blazer::Engine, at: "blazer"
end
