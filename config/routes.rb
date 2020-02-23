Rails.application.routes.draw do
  resources :certificate_authorities do
    member do
      get :openssl_ca
      get :openssl_req
    end
    resources :certificates do
      member do
        patch :revoke
      end
    end
    resources :users do
      member do
        post :grant
        post :revoke
      end
    end
  end
  resources :policies do
    resources :subject_attributes do
      collection do
        post :sort
      end
    end
  end

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  devise_scope :user do
    get 'sign_in', to: "devise/sessions#new", as: :new_user_session
    get 'sign_out', to: "devise/sessions#destroy", as: :destroy_user_session
  end

  root 'certificate_authorities#index'
end
