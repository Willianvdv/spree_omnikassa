SpreeOmnikassa
==============

Integrate Rabobank Omnikassa in your Spree commerce webshop


Using Spree Omnikassa
---------------------
Add spree_omnikassa to Gemfile

```ruby
gem 'spree_omnikassa', :git => 'git@github.com:oxpeck/spree_omnikassa.git
```

Update bundle

	$ bundle install

Run the omnikassa migrations

	$ bundle exec rake railties:install:migrations
	$ bundle exec rake db:migrate

Update Omnikassa settings (or leave them as they are for testing)

	http://0.0.0.0:3000/admin/omnikassa_settings/edit

Create a payment method with `Spree::BillingIntegration::Omnikassa` as provider.

Known issues
------------
* Onmikassa settings are not part of the payment method, the settings in the payment method are ignored
* Tested with 1-2-stable, 1.3 not tested yet
* Redirect to omnikassa from checkout is a slight hack, as can be seen in the 'app/controllers/spree/checkout_controller_decorator.rb'

I found a bug!
--------------

Fork + spec + pull request :-)