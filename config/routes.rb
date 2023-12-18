Rails.application.routes.draw do
  get 'search/index'
  get 'search/results'
  mount Nuttracker::Engine => "/nut"
  get 'help', to: 'help#index', as: 'help'
  get 'leaderboard', to: 'leaderboard#index', as: 'leaderboard'
  get 'notification/show'
  delete 'notification', to: 'notification#delete_all', as: 'clear_notifications'
  get 'porn_search/index'
  get 'porn_search/search'
  post 'porn_search/send_message_and_return/:message_thread', to: 'porn_search#send_message_and_return', as: 'porn_search_send_message_and_return'
  root 'dashboard#index'
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'session#new', as: 'login'
  get 'i-forgor', to: 'users#request_password_reset', as: 'forgor'
  post 'i-forgor', to: 'users#password_reset', as: 'forgor_commit'
  get 'i-forgor/commit/:password_reset_token', to: 'users#apply_new_password', as: 'forgor_apply'
  post 'i-forgor/commit/:password_reset_token', to: 'users#commit_apply_new_password', as: 'forgor_apply_commit'
  get 'logout', to: 'session#destroy', as: 'logout'
  get 'browse', to: 'links#browse'
  get 'users/:username', to: 'users#show'
  get 'users/:username/edit', to: 'users#edit'
  get 'users/:username/history', to: 'past_links#index', as: 'past_links'
  post 'users/:username/key', to: 'users#new_api_key', as: 'user_new_api_key'
  get 'notifications/:id', to: 'notification#show', as: 'notification'

  get 'search', to: 'search#index', as: 'search'
  get 'search/query', to: 'search#results', as: 'results'

  defaults format: :json do
    get 'api/links/:id.json', to: 'api#show_link'
    get 'api/links.json', to: 'api#all_links'
    get 'api/links/:id/widget.json', to: 'api#show_link_widget'
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
    collection do
      get 'resolve_thread_with/:user_id', to: 'message_thread#resolve', as: 'resolve'
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
      post 'abilities/:ability', to: 'links#toggle_ability', as: 'toggle_link_ability'
      post 'fork', to: 'links#fork', as: 'fork_link'
    end
    resources :comments
  end
  mount Blazer::Engine, at: "blazer"

  scope path: :mod_tools, as: 'mod_tools' do
    get '/', to: 'mod_tools#index', as: 'index'

    scope path: :passwords, as:'passwords' do
      get '/', to: 'mod_tools#show_password_reset', as: 'index'
      post 'update', to: 'mod_tools#update_password_reset', as: 'update'
    end
    get :user, to: 'mod_tools#show_user'
  end
end
