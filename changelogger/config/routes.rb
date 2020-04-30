Rails.application.routes.draw do
  root to: 'home#show'
  resources :webhooks, only: :create
end
