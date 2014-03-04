Spree Omnikassa 
===============

[![Build Status](https://travis-ci.org/Willianvdv/spree_omnikassa.png?branch=master)](https://travis-ci.org/Willianvdv/spree_omnikassa)
[![Coverage Status](https://coveralls.io/repos/Willianvdv/spree_omnikassa/badge.png?branch=master)](https://coveralls.io/r/Willianvdv/spree_omnikassa?branch=master)

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

	$ bundle exec rails g spree_omnikassa:install
	$ bundle exec rake db:migrate

Update Omnikassa settings (or leave them as they are for testing)

	http://0.0.0.0:3000/admin/omnikassa_settings/edit

Create a payment method with `Spree::BillingIntegration::Omnikassa` as provider.

---
Copyright (c) 2013 Willian van der Velde, released under the New BSD License
