Rails.application.routes.draw do

  devise_for :users
  get 'customers/main', as: 'user_root'
  get 'customers/profile'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'customers#main'
end
