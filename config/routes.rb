Rails.application.routes.draw do
  root 'questions#index'

  devise_for :users, controllers: { sessions: 'sessions' }

  resources :questions, only: [:index]
end