Upstairs::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Attachinary::Engine => "/attachinary"

  devise_for :users, :controllers => {:registrations => "registrations"}
  root to: "home#splash"
  get '/' => "home#splash", as: :home
  get '/about' => "home#about", as: :about
  get '/contact' => "home#contact", as: :contact
  get '/terms' => "home#terms_of_service", as: :terms_of_service
  get '/privacy' => "home#privacy", as: :privacy
  get '/welcome' => "users#home", as: :user_home

  resources :communities do
    resources :memberships, only: [:create, :destroy]
    resources :posts
    resources :alerts
    member do
     get 'gallery'
    end
  end

  resources :comments
  resources :posts
  resources :notifications, only: [:show, :destroy]

  resources :posts do
    resources :comments
  end

  resources :comments do
    resources :replies
  end

  resources :users , only: :show

end
