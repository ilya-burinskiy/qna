Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'
  
  resources :questions, except: %i[edit] do
    resources :answers, except: %i[index show new edit], shallow: true do
      patch :best, on: :member 
    end
  end

  resources :attachments, only: %i[destroy]
  resources :links, only: %i[destroy]
end
