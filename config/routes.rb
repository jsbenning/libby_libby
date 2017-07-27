Rails.application.routes.draw do

  root "home#logged_out"

  
  get 'logged_in' => 'home#logged_in'  

  resources :trades

  devise_for :users, controllers: {
    :omniauth_callbacks => 'users/omniauth_callbacks'
  }

  resources :users, only: [:show, :index, :edit, :update, :destroy] do
    resources :books, :except => [:index] do
      get :index, :on => :collection, :action => 'index_users'
    end
  end

  resources :books, only: [:index_all], :except => [:index] do
    get :index, :on => :collection, :action => 'index_all'
  end
  
end
