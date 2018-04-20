Rails.application.routes.draw do
  as :user do
    patch '/user/confirmation' => 'confirmations#update', as: :update_user_confirmation
  end

  devise_for :user, skip: [:omniauth_callbacks], controllers: {
    confirmations: 'confirmations',
    # passwords:     'passwords',
    registrations: 'registrations',
    # sessions:      'sessions',
    # unlocks:       'unlocks',
  }

  namespace :admin do
    resources :orders, only: [:index, :show] do
      collection do
        get :unaccepted, :accepted
        put :accept
      end
    end
  end

  resources :users, only: [:index, :show, :new, :create, :edit, :update]

  resources :orders, only: [:index, :show, :new, :create, :edit, :update] do
    get :placed, on: :collection
    put :place, on: :member
  end

  root to: 'orders#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end
