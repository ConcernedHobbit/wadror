Rails.application.routes.draw do
  resources :beers
  resources :breweries

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get 'ratings', to: 'ratings#index'

  # Defines the root path route ("/")
  root 'breweries#index'
end
