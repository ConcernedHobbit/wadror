Rails.application.routes.draw do
  resources :memberships
  resources :beer_clubs
  resources :users
  resources :beers
  resources :breweries
  resources :ratings, only: [:index, :new, :create, :destroy]
  resources :places, only: [:index, :show]
  resource :session, only: [:new, :create, :destroy]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'

  post 'places', to: 'places#search'

  # Defines the root path route ("/")
  root 'breweries#index'
end
