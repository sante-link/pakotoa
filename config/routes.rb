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

  devise_for :users

  root 'certificate_authorities#index'
end
