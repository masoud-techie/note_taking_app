Rails.application.routes.draw do
  get "note_shares/create"
  get "note_shares/destroy"
  get "pages/home"
  # Devise authentication
  devise_for :users

  # Root page
  root "pages#index"

  # Notes CRUD routes
  resources :notes do
    # Collection route for favorite notes
    collection do
      get :favorites
    end

    member do
      patch :toggle_favorite
    end

    resources :note_shares, only: :create
  end

  resources :note_shares, only: :destroy


end
