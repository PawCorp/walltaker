Nuttracker::Engine.routes.draw do
  resources :orgasms
  get 'orgasmers/:username', to: 'orgasms#index_for_user'
end
