Rails.application.routes.draw do
  get  '/', to: 'home#show'
  post '/', to: 'webhooks#create'
end
