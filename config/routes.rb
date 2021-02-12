Rails.application.routes.draw do
  resources :publishing_houses
  resources :authors
  resources :books
  resource :github, only: :create
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
