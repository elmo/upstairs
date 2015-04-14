Upstairs::Application.routes.draw do
  devise_for :users
  root to: "home#index"
  get '/' => "home#index", as: :home
  get '/about' => "home#about", as: :about
  get '/contact' => "home#contact", as: :contact
  get '/terms' => "home#terms_of_service", as: :terms_of_service
  get '/privacy' => "home#privacy", as: :privacy
  get '/welcome' => "users#home", as: :user_home

  resources :communities do
    resources :memberships, only: [:create, :destroy]
  end
end
