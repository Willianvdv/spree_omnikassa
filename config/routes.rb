Spree::Core::Engine.routes.draw do
  get '/omnikassa/start/:payment_id/:token/', 
      :to => 'omnikassa#start', 
      :as => :omnikassa_start
  get '/omnikassa/error/:payment_id/:token/', 
      :to => 'omnikassa#error', 
      :as => :omnikassa_error
  post '/omnikassa/success/:payment_id/:token/', 
      :to => 'omnikassa#success', 
      :as => :omnikassa_success
  post '/omnikassa/success/automatic/:payment_id/:token/', 
      :to => 'omnikassa#automatic', 
      :as => :omnikassa_success_automatic
end
