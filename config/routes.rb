Rails.application.routes.draw do
  get 'errors/not_found'
  get 'errors/server_error'

  get 'users/:user_id/kinks', to: 'kink#users_kinks', as: 'user_kinks'
  get 'kinks/new', to: 'kink#new', as: 'kink_new_form'
  get 'kinks/:id', to: 'kink#show', as: 'kink_show'
  post 'kinks(/:id)', to: 'kink#update', as: 'kink'
  post 'kinks(/:id)/star', to: 'kink#toggle_star', as: 'kink_toggle_star'
  post 'kinks/:id/test/e621', to: 'kink#test_on_e621', as: 'kink_e621'
  delete 'kinks/:id', to: 'kink#remove', as: 'kink_remove'

  get 'settings/index'
  get 'settings/save'
  get 'search/index'
  get 'search/results'
  mount Nuttracker::Engine => "/nut"
  mount Crono::Engine, at: '/pornbot'
  get 'help', to: 'help#index', as: 'help'
  get 'help/faq', to: 'help#faq', as: 'faq'
  get 'help/client_guide', to: 'help#client_guide', as: 'client_guide'
  get 'leaderboard', to: 'leaderboard#index', as: 'leaderboard'
  get 'notification/show'
  delete 'notification', to: 'notification#delete_all', as: 'clear_notifications'
  get 'porn_search/index'
  get 'porn_search/search'
  get 'porn_search/search/kinks_for/:link_id', to: 'kink#search_kinks', as: 'search_kinks'
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
  get 'users/:username/sets', to: 'users#sets', as: 'user_sets'
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

  post 'api/mascot/next', to: 'api#update_mascot'
  post 'api/pervert/toggle', to: 'api#update_perviness'

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
    collection do
      get 'wizard', to: 'link_wizard#spawn_link', as: :spawn_link
    end

    member do
      get :walltaker, to: 'links#export'
      post 'abilities/:ability', to: 'links#toggle_ability', as: 'toggle_link_ability'
      post 'fork', to: 'links#fork', as: 'fork_link'
    end

    resources :comments
    resources :link_wizard, controller: 'link_wizard', path: :wizard, as: :wizard do
      member do
        post :apply, to: 'link_wizard#apply', as: 'apply'
      end
    end
  end

  resources :surrenders

  get '/settings', to: 'settings#index', as: 'settings'
  post '/settings', to: 'settings#save'

  mount Blazer::Engine, at: "blazer"

  scope path: :mod_tools, as: 'mod_tools' do
    get '/', to: 'mod_tools#index', as: 'index'

    scope path: :passwords, as: 'passwords' do
      get '/', to: 'mod_tools#show_password_reset', as: 'index'
      post 'update', to: 'mod_tools#update_password_reset', as: 'update'
    end

    scope path: :users, as: 'users' do
      get '/', to: 'mod_tools#show_user', as: 'index'
      get '/assume/:user', to: 'mod_tools#assume_user', as: 'assume'
      post 'update', to: 'mod_tools#update_user', as: 'update'
    end

    scope path: :quarantine, as: 'quarantine' do
      get '/', to: 'mod_tools#show_quarantine', as: 'index'
      post 'update/:user', to: 'mod_tools#update_quarantine', as: 'update'
      post 'ban/:user', to: 'mod_tools#update_ipban', as: 'ipban'
    end

    scope path: :events, as: 'events' do
      get '/', to: 'mod_tools#show_recent_events', as: 'index'
      post 'ban/:event', to: 'mod_tools#update_ipban_by_event', as: 'ipban'
    end
  end

  scope path: :lizard_tools, as: 'lizard_tools', controller: 'lizard_tools' do
    get '/', action: 'index', as: 'index'
    get 'warren', as: 'warren'
    get 'ki', as: 'ki'
    get 'taylor', as: 'taylor'
  end

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#server_error", via: :all
end
