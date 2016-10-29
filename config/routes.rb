Rails.application.routes.draw do

  root "home#index"


  resources :trades, only: [:index, :new, :create, :edit, :update]

  resources :messages, only: [:index, :new, :create]

  devise_for :users, :path => 'accounts', controllers: {
    :omniauth_callbacks => 'users/omniauth_callbacks'
  }

  resources :users, only: [:show] do
    resources :books, :except => [:index] do
      get :index, :on => :collection, :action => 'index_users'
    end
  end

  resources :books, only: [:index_all], :except => [:index] do
    get :index, :on => :collection, :action => 'index_all'
  end
  
end
