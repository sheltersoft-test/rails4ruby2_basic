Rails.application.routes.draw do

  mount Tolk::Engine => '/translation_tool', :as => 'tolk'
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  
  devise_for :users, controllers: { sessions: "users/sessions", confirmations: 'users/confirmations', 
                                    :registrations => 'users/registrations', :passwords => 'users/passwords',
                                    :mailer => 'users/mailer' }
  ActiveAdmin.routes(self)
  
  devise_scope :user do
    get "sign_in", to: "users/sessions#new"
    get "sign_out", to: "users/sessions#destroy"
    get "sign_up", to: "users/registrations#new"
    get "forgot_password", to: "users/passwords#new"
  end

  # users
  resources :user do
    collection do
      get 'user_edit_password/(:id)', to: "user#edit", as: 'user_edit_password'
      patch 'update_password', to: "user#update_password", as: 'update_password'
      get 'edit_profile', to: "user#edit_profile", as: "edit_profile"
      patch 'update_profile', to: "user#update_profile", as: 'update_profile'
      match 'update_old_password', to: "user#update_old_password", as: 'update_old_password', via: [:post, :patch]
    end
  end
  
  # executives
  resources :executives do
    collection do
      get 'desktop'
      get 'business_management'
      get 'user_register'
      post "/search/user_filter" => "executives#user_filter", :as => :user_filter
      get 'next_users/:page', to: 'executives#next_users', as: 'next_users'
    end
  end

  # directors
  resources :directors do
    collection do
      get 'desktop'
      get 'user_register'
      post "/search/user_filter" => "directors#user_filter", :as => :user_filter
      get 'next_users/:page', to: 'directors#next_users', as: 'next_users'
    end
  end

  # dentists
  resources :dentists do
    collection do
      get 'desktop'
      post "/search/user_filter" => "dentists#user_filter", :as => :user_filter
      get 'next_users/:page', to: 'dentists#next_users', as: 'next_users'
    end
  end

  # emails
  resources :emails do
    collection do
      post '/order_dbm_email', to: 'emails#order_dbm_email', as: 'order_dbm_email'
      post '/send_feedback_email', to: 'emails#send_feedback_email', as: 'send_feedback_email'
      post '/:id/send_login_info_email', to: 'emails#send_login_info_email', as: 'send_login_info_email'
    end
  end

  resources :resources do
      member do
        post 'save_media', to: 'resources#save_media'
        post 'delete_media', to: 'resources#delete_media'
        get 'download', :to => 'resources#download'
        post 'save_signature', to: 'resources#save_signature'
        post 'get_signature', to: 'resources#get_signature'
      end    
    end
  get '/resources/get_resource_holders', :to => 'resources#get_resource_holders', :as => 'resources_get_resource_holders'

  #settings
  resources :settings, only: [] do
    collection do
      post "/soft/:action_type/:object_type/:object_id" => "settings#soft_delete", as: :soft_delete
      get '/more_options/:object_type/:object_id' => "settings#more_options", :as => :more_options
      get '/more_options/:object_type/:object_id/remove' => "settings#remove_user_data", :as => :remove_user_data
      match "/personal/edit" => "settings#my_settings", :as => :personal, via: [:get, :patch]
    end
  end

  #pdf
  resources :pdf, only: [] do
    member do
      # send PDF
      get 'send_pdf', to: 'pdf#send_pdf', as: 'send'
    end
  end
  
  root 'desktop#index'
end
