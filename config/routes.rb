require 'sidekiq/web'

Rails.application.routes.draw do
  if !Rails.env.production?
    get 'doc/v2'
  end

  mount Base => '/api' #api

  root 'questions#index'

  authenticate :admin do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, controllers: { sessions: 'sessions' }
  devise_for :admins, controllers: { sessions: 'admins/sessions' }

  resources :questions, only: [:index, :new, :create, :show, :edit, :update] do
    member do
      put :nullify
      put :to_dispatcher
      put :to_engineer
      get :edit_content
      get :edit_tags
      get :edit_auto_submodel
      get :edit_images
      put :update_images
    end

    collection do
      get :search
      get :dispatcher_questions, as: :dispatcher
      get :specialist_questions, as: :specialist
      get :my_processed_questions, as: :my_processed
    end

    resources :answers, only: [:new, :create]
  end

  resources :answers, only: [:edit, :update] do
    member do
      put :adopt
    end
  end

  resources :auto_brands, only: [] do
    resources :auto_models, only: [:index]
  end

  resources :auto_models, only: [] do
    resources :auto_submodels, only: [:index]
  end

  # 问题库暂时不用question_bases表
  # resources :question_bases, only: [:index, :new, :create]

  # Admin是model（class），这意味着Admin就不能再是module，所以不能用:admin来做namespace，而要用:admins
  # 但是devise又要调用admin_root_path，所以这里用了 namespace :admins, as: :admin
  # 使得path name用的是admin，而namespace仍然是admins
  namespace :admins, as: :admin do
    root 'questions#index'

    resources :questions, only: [:index]
    resources :users, only: [] do
      member do
        put :sign_in_as
      end

      collection do
        get :be_able_to_sign_in
      end
    end
  end
end