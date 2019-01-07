# frozen_string_literal: true

# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  root to: 'catalogs#index'

  # static pages
  get 'misc-info', to: 'statics#misc_info'

  # Auth0
  get 'auth/oauth2/callback', to: 'auth0#callback', as: 'auth_callback'
  get 'auth/failure', to: 'auth0#failure', as: 'auth_failure'
  get 'auth/logout', to: 'auth0#logout', as: 'logout'

  # Products
  resources :articles do
    resources :article_publications
    collection do
      get 'search', to: 'articles#search', as: 'search'
    end
    member do
      delete 'pictures/:pic_id', to: 'articles#delete_picture', as: 'pictures'
    end
  end
  resources :catalogs do
    resources :article_publications
    collection do
      get 'search', to: 'catalogs#search', as: 'search'
    end
    member do
      delete 'picture', to: 'catalogs#delete_picture', as: 'picture'
    end
  end
  resources :article_publications, only: [:create, :show, :update, :destroy]
end
