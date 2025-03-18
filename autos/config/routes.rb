Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/swagger'
  mount Rswag::Api::Engine => '/swagger'
  
  resources :brands, only: [:index, :create] do
    resources :models, only: [:index, :create]
  end

  resources :models, only: [:index, :update]
end