Rails.application.routes.draw do
  get 'trades/show'

  get 'messages/new'

  get 'messages/show'

  get 'books/new'

  get 'books/show'

  get 'books/index'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
