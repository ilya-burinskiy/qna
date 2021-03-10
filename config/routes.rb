Rails.application.routes.draw do
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
    resources :answers, concerns: [:votable], except: %i[index show new edit], shallow: true do
      patch :best, on: :member 
    end
  end

  resources :attachments, only: %i[destroy]
  resources :links, only: %i[destroy]
  resources :rewards, only: %i[index]

  mount ActionCable.server => '/cable'
end
