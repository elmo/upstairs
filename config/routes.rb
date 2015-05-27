Upstairs::Application.routes.draw do
  resources :messages

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Attachinary::Engine => "/attachinary"

  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions"}

  devise_scope :user do
    get "/join" => "devise/registrations#new"
    get "/login" => "devise/sessions#new"
  end

  root to: "home#home"
  get '/' => "home#home", as: :home
  get '/about' => "home#about", as: :about
  get '/contact' => "home#contact", as: :contact
  get '/terms' => "home#terms_of_service", as: :terms_of_service
  get '/privacy' => "home#privacy", as: :privacy
  get '/welcome' => "users#home", as: :user_home
  get '/find' => "communities#choose", as: :find_community

  resources :communities do
    resources :memberships, only: [:create, :destroy, :index]
    resources :posts
    resources :alerts
    resources :tickets
    resources :invitations do
      get 'redeem'
    end
    resources :messages do
     put 'read'
    end
    resources :user_invitations, controller: 'invitations', type: 'UserInvitation'
    resources :landlord_invitations, controller: 'invitations', type: 'LandlordInvitation'
    resources :manager_invitations, controller: 'invitations', type: 'ManagerInvitation'

    resources :users, only: [:show]
    member do
     get 'gallery'
    end
  end

  resources :notifications, only: [:show, :destroy]

  resources :tickets do
      resources :comments
  end

  resources :posts do
    resources :comments
  end

  resources :comments do
    resources :replies
  end

end
