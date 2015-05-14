require 'sidekiq/web'

Rails.application.routes.draw do
  root 'questions#index'

  # TODO: 应该只允许admin访问
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: { sessions: 'sessions' }

  resources :questions, only: [:index, :new, :create] do
    member do
      put :nullify
      put :to_dispatcher
      put :to_engineer
    end

    collection do
      get :dispatcher_questions, as: :dispatcher
      get :expert_questions, as: :expert
    end
  end

  resources :question_bases, only: [:index, :new, :create]
end