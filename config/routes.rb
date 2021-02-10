Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'
  
  resources :questions do
    resources :answers, except: %i[index show new], shallow: true
  end
end
