require 'sidekiq/web'

Rails.application.routes.draw do
  root 'questions#index'

  # TODO: 应该只允许admin访问
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: { sessions: 'sessions' }

  resources :questions, only: [:index, :new, :create]
end