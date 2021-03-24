Rails.application.routes.draw do
  use_doorkeeper

  devise_for :users
  root to: 'questions#index'

  concern :votable do
    member do
      post :vote_for
      post :vote_against
      delete :unvote
    end
  end

  resources :questions, concerns: [:votable], except: %i[edit] do
    resources :comments, only: [:create]

    resources :answers, concerns: [:votable], except: %i[index show new edit], shallow: true do
      resources :comments, only: [:create], shallow: false

      patch :best, on: :member 
    end
  end

  resources :attachments, only: %i[destroy]
  resources :links, only: %i[destroy]
  resources :rewards, only: %i[index]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, except: [:edit, :new] do
        resources :answers, except: [:edit, :new], shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
end
