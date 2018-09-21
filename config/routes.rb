Rails.application.routes.draw do

  devise_for :users
  get 'orders/index', as: 'user_root'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'orders#index'
end
