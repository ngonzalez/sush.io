Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'github#index'
  get '/github', to: 'github#list'
  put '/github', to: 'github#update'
end