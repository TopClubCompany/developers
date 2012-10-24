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
    get 'static_pages/:structure_id' => 'static_pages#show'
    root :to => "dashboards#index"
    resources :dashboards
    resources :categories do
      post :batch, :on => :collection
      post :rebuild, :on => :collection
    end

    resources :assets, :only => [:create, :destroy] do
      post :sort, :on => :collection
      get :description, :on => :collection
      post :update_description, :on => :collection
    end

    resources(:users) do
      post :batch, :on => :collection
      post :activate, :suspend, :on => :member
    end
    resources(:kitchens) do
      post :batch, :on => :collection
    end
  end
  mount Ckeditor::Engine => "/ckeditor"
end
