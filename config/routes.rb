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

  namespace :admin do
    root :to => "dashboards#index"
    resources :dashboards
    resources(:users) do
      post :batch, :on => :collection
      post :activate, :suspend, :on => :member
  end
  end
end
