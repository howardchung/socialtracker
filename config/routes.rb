SignInWithTwitter::Application.routes.draw do
  root to: 'home#index'
  get '/auth/twitter/callback', to: 'twitter#create', as: 'callback'
  get '/auth/failure', to: 'twitter#error', as: 'failure'
  get 'twitter/profile', to: 'twitter#show', as: 'show'
  delete '/signout', to: 'twitter#destroy', as: 'signout'
  get 'facebook/profile', to:'facebook#show'
  get 'facebook/getToken'
  get 'facebook/update'
  get 'twitter/update'
end
