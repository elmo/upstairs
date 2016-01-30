Upstairs::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Attachinary::Engine => '/attachinary' unless Rails.env.test?

  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions', omniauth_callbacks: 'callbacks', invitations: 'users/invitations' }

  devise_scope :user do
    get '/join' => 'devise/registrations#new'
    get '/login' => 'devise/sessions#new'
    get '/invite/:id' => 'invitations#welcome', as: :invite
  end

  root to: 'home#home'
  get '/' => 'home#home', as: :home
  get '/go/:id' => 'dispatch#redirect', as: :dispatch
  get '/about' => 'home#about', as: :about
  get '/contact' => 'home#contact', as: :contact
  get '/terms' => 'home#terms_of_service', as: :terms_of_service
  get '/privacy' => 'home#privacy', as: :privacy
  get '/help' => 'home#help', as: :help
  get '/find' => 'buildings#choose', as: :find_building
  get '/buildings/:building_id/calendar' => 'events#index', as: :calendar

  get '/welcome' => 'users#welcome', :via  => :get
  put '/acknowledge' => 'users#acknowledge'

  namespace :manage do
    resources :manager_invitations
    resources :messages, only: :index
    resources :buildings do
      resources :units
       resources :messages do
         member do
           put 'mark_as_read'
           put 'mark_as_unread'
         end
       end
    end
    resources :posts
      resources :memberships
    resources :alerts
    resources :tickets
    resources :events
    resources :units do
      resources :tenancies
    end
  end

  namespace :api do
    resources :user, only: [:show] do
    end
    resources :buildings, only: [:show] do
      resources :posts do
        collection do
          get 'tips'
        end
        resources :comments
      end
      resources :events do
        collection do
          get 'calendar'
        end
        resources :comments
      end
      resources :alerts do
        resources :comments
      end
      resources :tickets do
        resources :comments
      end
    end
  end

  resources :verifications, only: [:index, :destroy] do
    member do
      put 'revoke'
    end
  end
  resources :verification_requests, only: [:index, :edit, :update, :destroy, :show] do
    member do
      put 'reject'
    end
    resources :verifications, only: [:new, :create]
  end

  resources :buildings do
    member do
      get 'declare_ownership'
      get 'landlord_onboarding'
      get 'invite_your_landlord'
      get 'residents'
      get 'building'
      get 'managers'
      get 'guests'
      get 'vendors'
    end
    resources :memberships, only: [:create, :destroy, :index] do
      member do
        put 'grant'
        put 'revoke'
      end
    end
    resources :posts do
      collection do
        get 'tips'
      end
    end
    resources :alerts
    resources :tickets do
      member do
        put 'open'
        put 'close'
        put 'escalate'
        put 'deescalate'
      end
    end
    resources :messages do
      member do
        put 'read'
        put 'unread'
      end
    end
    resources :invitations do
      get 'redeem'
    end
    resources :verification_requests, only: [:new, :create]
    resources :photos
    resources :events
    resources :user_invitations, controller: 'invitations', type: 'UserInvitation'
    resources :landlord_invitations, controller: 'invitations', type: 'LandlordInvitation'
    resources :manager_invitations, controller: 'invitations', type: 'ManagerInvitation'

    resources :users, only: [:show, :welcome] do
      resources :messages
    end

    resources :units do
      resources :comments
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
