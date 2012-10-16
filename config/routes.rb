Topclub::Application.routes.draw do

  devise_for :users

  root :to => 'explore#index'

  resources :explore

  resources :places do
    member do
      post :rate
      post :favorite
      post :planned
      post :visited
    end
  end

  resources :sandboxes do
    collection do
      get :search
      get :explorer
      get :search_map
      get :places
      get :stream
    end
  end
end
