Spree::Core::Engine.routes.draw do
  get '/omnikassa/start/', :to => 'omnikassa#start', :as => :omnikassa_start
  get '/omnikassa/error/', :to => 'omnikassa#error', :as => :omnikassa_error
  get '/omnikassa/success/', :to => 'omnikassa#success', :as => :omnikassa_success
  get '/omnikassa/success/automatic/', :to => 'omnikassa#automatic', :as => :omnikassa_automatic
end
