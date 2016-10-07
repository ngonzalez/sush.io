Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'github#index'
  get '/github', to: 'github#index'
  get '/github/list', to: 'github#list'
  get '/users', to: 'users#index'
end