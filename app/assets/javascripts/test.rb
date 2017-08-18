  devise_for :users, :path => 'accounts', controllers: {
    :omniauth_callbacks => 'users/omniauth_callbacks'
  }