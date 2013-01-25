Spree::Core::Engine.routes.draw do
  get '/omnikassa/start/:payment_id/',
      :to => 'omnikassa#start',
      :as => :omnikassa_start
  get '/omnikassa/error/:payment_id/',
      :to => 'omnikassa#error',
      :as => :omnikassa_error
  post '/omnikassa/success/:payment_id/',
      :to => 'omnikassa#success',
      :as => :omnikassa_success
  post '/omnikassa/success/automatic/:payment_id/',
      :to => 'omnikassa#success_automatic',
      :as => :omnikassa_success_automatic

  namespace :admin do
    resource :omnikassa_settings
  end
end
