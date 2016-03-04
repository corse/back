Rails.application.routes.draw do
  namespace :v1 do
    post 'auth/login'
    post 'auth/signup'
    post 'auth/request_confirm'
    post 'auth/request_reset'
    post  'auth/confirm'
    post 'auth/reset'
    resources :clients
    resources :profiles
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end
