Rails.application.routes.draw do
  devise_for :users
  resources :hashtags, only: [:show]
  get 'hello/index' => 'hello#index'
  get 'hello/link' => 'hello#link'
  resources :users, only: [:show] 
  resources :tweets
  resources :presents

  root 'hello#index'
end
