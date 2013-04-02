Topclub::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  filter :locale

  post '/set_location/:location_slug' => 'places#set_location', as: 'set_location'

  match "users/auth/:provider", :to => redirect("/users/auth/%{provider}")
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  delete '/sign_out' => 'users/omniauth_callbacks#destroy_user_session', as: 'quit'

  match '/enter_email(/:used_email)' => 'users/omniauth_callbacks#enter_email', as: 'enter_email'

  get '/confirm_account(/:token)' => 'users/omniauth_callbacks#confirm_account', as: 'confirm_account'

  post '/user_registration' => 'users/omniauth_callbacks#user_registration', as: 'user_registration'

  get '/profile/:user_id/show_reservation/:reservation_id' => 'users/profile#show_reservation', as: 'show_profile_reservation'
  get '/profile/:user_id/edit_reservation/:reservation_id' => 'users/profile#edit_reservation', as: 'edit_profile_reservation'
  get '/profile/:user_id/cancel_reservation/:reservation_id' => 'users/profile#cancel_reservation', as: 'cancel_profile_reservation'
  put '/update_reservation/:reservation_id' => 'users/profile#update_reservation', as: 'update_reservation'

  post '/reviews/:review_id/:vote_type' => 'reviews#set_usefulness', as: 'set_review_usefulness'
  post '/reviews' => 'reviews#create', as: 'review_create'
  post '/set_unset_favorite_place/:id' => 'places#set_unset_favorite', as: 'set_unset_favorite_place'



  resources :profile, module: :users do
    member do
      get :invite_friends
      get :self_reviews
      get :settings
      get :edit_settings
      get :favourites
      put :update_settings
      get :disconnected
      get :reservations
    end

    collection do
      post :send_email_invitation
    end
  end


  get '/new_reservation/:date,:place_id,:time,:amount_of_person' => 'reservations#new_reservation', as: 'new_reservation'

  get '/reservation_confirmed/:reservation_id' => 'reservations#reservation_confirmed', as: 'reservation_confirmed'

  post '/complete_reservation' => 'reservations#complete_reservation', as: 'complete_reservation'



  match 'autocomplete' => AutocompleteApp

  root :to => 'explore#index'

  resources :explore do
    collection do
      get :get_more
    end
  end

  resources :reviews do
    collection do
      post :vote
    end
  end

  resources :reservations do
    member do
      get :print
      get :create_account
    end
    collection do
      get :available_time
    end
  end


  resources :pages do
    collection do
      post :save_cooperation
    end
  end

  resources :search do
    collection do
      get :get_more
      get :search
    end
  end

  resources :places do
    member do
      get :more
    end
  end


  namespace :admin do

    match 'main_image' => AdminMainImageApp
    match 'autocomplete' => AdminAutocompleteApp
    match 'place_feature' => PlaceFeatureApp

    get 'static_pages/:structure_id' => 'static_pages#show'

    root :to => "dashboards#index"

    resources :dashboards

    resources :main_sliders do

    end

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

    resources :letters do
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

    resources :structures do
      post :rebuild, :on => :collection
      resource :static_page
      post :batch, :on => :collection
    end

    resources :user_notifications do
      post :batch, :on => :collection
    end

    resources :cooperations do
      post :batch, :on => :collection
    end

    resources :reservations do
      post :batch, :on => :collection
    end

  end
  mount Ckeditor::Engine => "/ckeditor"
  mount Resque::Server, :at => "/resque"

  match '/:id' => "places#show", :as => "place"



end
