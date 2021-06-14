Rails.application.routes.draw do
  get 'home/index'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'auth/google_oauth2/callback/', to: 'home#redirect', as: :google_webhook
  resources :users do
    get 'link_gmail'
  end
  root to: "home#index"
end
