Rails.application.routes.draw do


  resources :trades, only: [:index]

  resources :messages, only: [:index, :new, :create]

  devise_for :users, :path => 'accounts'

  resources :users do
    resources :books, only: [:index, :new, :create]
  end
  resources :books, only: [:show, :edit, :update, :destroy]
  
end
