Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount ActionCable.server => '/cable'

  resources :tasks

  root to: "tasks#index"

  # api

  namespace :api do
    namespace :v1 do
      resources :tasks, only: [:index, :create, :show, :update]
    end
  end
end
