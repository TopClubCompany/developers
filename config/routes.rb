Topclub::Application.routes.draw do

  filter :locale

  post '/set_location/:location_slug' => 'places#set_location', as: 'set_location'

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  delete '/sign_out' => 'users/omniauth_callbacks#destroy_user_session', as: 'quit'

  match '/enter_email(/:used_email)' => 'users/omniauth_callbacks#enter_email', as: 'enter_email'

  get '/confirm_account(/:token)' => 'users/omniauth_callbacks#confirm_account', as: 'confirm_account'

  post '/user_registration' => 'users/omniauth_callbacks#user_registration', as: 'user_registration'

  get '/profile/:user_id' => 'users/profile#show', as: 'profile'
  get '/profile/:user_id/invite_friends' => 'users/profile#invite_friends', as: 'invite_friends'
  post '/profile/send_email_invitation_path' => 'users/profile#send_email_invitation', as: 'send_email_invitation'

  match 'autocomplete' => AutocompleteApp

  root :to => 'explore#index'

  resources :explore

  resources :search do
    collection do
      get :get_more
      get :search
    end
  end

  resources :places do
    member do
      post :rate
      post :favorite
      post :planned
      post :visited
    end
    #collection do
    #  get :show
    #end
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

    match 'main_image' => AdminMainImageApp
    match 'autocomplete' => AdminAutocompleteApp
    match 'place_feature' => PlaceFeatureApp

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
    resources(:places) do
      post :batch, :on => :collection
    end
    resources(:group_features) do
      post :batch, :on => :collection
    end

    resources(:feature_items) do
      post :batch, :on => :collection
    end
    resources :locators do
      post :prepare, :reload, :cache_clear, :on => :collection
    end

    resources(:mark_types) do
      post :batch, :on => :collection
    end

    resources :cities do
      post :batch, :on => :collection
    end

  end
  mount Ckeditor::Engine => "/ckeditor"
end
