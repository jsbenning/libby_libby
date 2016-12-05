Rails.application.routes.draw do

  root "home#index"

  resources :reviews, only: [:new, :show]

  resources :trades

  devise_for :users, :path => 'accounts', controllers: {
    :omniauth_callbacks => 'users/omniauth_callbacks'
  }

  resources :users, only: [:show, :index, :edit, :update] do
    resources :books, :except => [:index] do
      get :index, :on => :collection, :action => 'index_users'
    end
  end

  resources :books, only: [:index_all], :except => [:index] do
    get :index, :on => :collection, :action => 'index_all'
  end
  
end
