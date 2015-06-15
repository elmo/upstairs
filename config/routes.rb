Upstairs::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Attachinary::Engine => "/attachinary"

  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions"}

  devise_scope :user do
    get "/join" => "devise/registrations#new"
    get "/login" => "devise/sessions#new"
    get "/invite/:id" => "invitations#welcome", as: :invite
  end

  root to: "home#home"
  get '/' => "home#home", as: :home
  get '/go/:id' => "dispatch#redirect", as: :dispatch
  get '/about' => "home#about", as: :about
  get '/contact' => "home#contact", as: :contact
  get '/terms' => "home#terms_of_service", as: :terms_of_service
  get '/privacy' => "home#privacy", as: :privacy
  get '/help' => "home#help", as: :help
  get '/find' => "buildings#choose", as: :find_building
  get '/buildings/:building_id/inbox' => "messages#inbox", as: :inbox
  get '/buildings/:building_id/outbox' => "messages#outbox", as: :outbox
  get '/buildings/:building_id/calendar' => "events#index", as: :calendar

  resources :buildings do
    resources :memberships, only: [:create, :destroy, :index]
    resources :posts
    resources :alerts
    resources :tickets
    resources :messages
    resources :invitations do
      get 'redeem'
    end

    resources :photos
    resources :events
    resources :user_invitations, controller: 'invitations', type: 'UserInvitation'
    resources :landlord_invitations, controller: 'invitations', type: 'LandlordInvitation'
    resources :manager_invitations, controller: 'invitations', type: 'ManagerInvitation'

    resources :users, only: [:show] do
      resources :messages
    end

    resources :photos
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

  resources :events do
    resources :comments
  end

  resources :comments do
    resources :replies
  end

end
