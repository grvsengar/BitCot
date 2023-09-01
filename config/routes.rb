Rails.application.routes.draw do
  resources :activities, only: [:index]
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'users#index'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
  sessions: 'users/sessions',
  registrations: 'users/registrations' }
  resources :users, only: %i[index show] do
    resources :friendships, only: %i[create] do
      collection do
        get 'accept_friend'
        get 'decline_friend'
      end
    end
  end
  put '/users/:id', to:  'users#update_img'
  get '/saw_notification', to: 'users#saw_notification', as: 'saw_notice'

  resources :posts, only: %i[index new create show destroy] do
      resources :likes, only: %i[create]
      member do
        patch :archive
      end
  end
  resources :comments, only: %i[new create destroy] do
    resources :likes, only: %i[create]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
