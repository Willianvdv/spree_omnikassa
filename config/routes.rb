Spree::Core::Engine.add_routes do

  get '/omnikassa/start/:payment_id/',
      :to => 'omnikassa#start',
      :as => :omnikassa_start
  get '/omnikassa/error/:payment_id/',
      :to => 'omnikassa#error',
      :as => :omnikassa_error
  get '/omnikassa/restart/:order_id/',
      :to => 'omnikassa#restart',
      :as => :omnikassa_restart
  get '/omnikassa/pending/:order_id/',
      :to => 'omnikassa#pending',
      :as => :omnikassa_pending
  post '/omnikassa/success/:payment_id/',
      :to => 'omnikassa#success',
      :as => :omnikassa_success
  post '/omnikassa/success/automatic/:payment_id/',
      :to => 'omnikassa#success',
      :as => :omnikassa_success_automatic

  namespace :admin do
    resource :omnikassa_settings
  end
end
