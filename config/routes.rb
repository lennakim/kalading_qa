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
      get :specialist_questions, as: :specialist
      get :my_processed_questions, as: :my_processed
    end

    resources :answers, only: [:new, :create]
  end

  resources :answers, only: [] do
    member do
      put :adopt
    end
  end

  resources :question_bases, only: [:index, :new, :create]
end