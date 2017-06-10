Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Sign up
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  # Log in
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'

  # Log out
  match '/logout', to: 'sessions#destroy', via: %i[get delete]

  root to: 'homepage#index'
end
