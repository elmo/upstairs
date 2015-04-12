Upstairs::Application.routes.draw do
  devise_for :users
  root to: "home#index"
  get '/' => "home#index", as: :home
  get '/about' => "home#about", as: :about
  get '/contact' => "home#contact", as: :contact
end
