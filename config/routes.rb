SignInWithTwitter::Application.routes.draw do
  root to: 'sessions#index'
  get '/auth/twitter/callback', to: 'sessions#create', as: 'callback'
  get '/auth/failure', to: 'sessions#error', as: 'failure'
  get '/profile', to: 'sessions#show', as: 'show'
  delete '/signout', to: 'sessions#destroy', as: 'signout'
end
