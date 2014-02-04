Spree Omnikassa 
===============

[![Build Status](https://travis-ci.org/oxpeck/spree_omnikassa.png?branch=master)](https://travis-ci.org/oxpeck/spree_omnikassa)

Integrate Rabobank Omnikassa in your Spree commerce webshop


Using Spree Omnikassa
---------------------
Add spree_omnikassa to your Gemfile

```ruby
gem 'spree_omnikassa', github: 'Willianvdv/spree_omnikassa'
```

Update bundle

	$ bundle install

Run the omnikassa migrations

	$ bundle exec rake railties:install:migrations
	$ bundle exec rake db:migrate

Update Omnikassa settings (or leave them as they are for testing)

	http://0.0.0.0:3000/admin/omnikassa_settings/edit

Create a payment method with `Spree::BillingIntegration::Omnikassa` as provider.

I found a bug!
--------------

Fork + spec + pull request :-)