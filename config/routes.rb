require 'sidekiq/web'

Rails.application.routes.draw do
  get 'doc/v2'
  mount Base => '/api' #api

  root 'questions#index'

  # TODO: 应该只允许admin访问
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: { sessions: 'sessions' }
  devise_for :admins, controllers: { sessions: 'admins/sessions' }

  resources :questions, only: [:index, :new, :create, :show] do
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

  # Admin是model（class），这意味着Admin就不能再是module，所以不能用:admin来做namespace，而要用:admins
  # 但是devise又要调用admin_root_path，所以这里用了 namespace :admins, as: :admin
  # 使得path name用的是admin，而namespace仍然是admins
  namespace :admins, as: :admin do
    root 'questions#index'

    resources :questions, only: [:index]
  end
end