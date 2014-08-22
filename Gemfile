source 'https://rubygems.org'

gem 'coveralls', require: false
gem 'spree_auth_devise', github: 'spree/spree_auth_devise', branch: '2-3-stable'
gem 'spree', github: 'spree/spree', branch: '2-3-stable'
gem 'sass-rails', github: 'rails/sass-rails'

group :test do
  #gem 'pg'
  gem 'database_cleaner', '~> 1.0.1'
  #gem 'selenium-webdriver', '~> 2.35'
  gem 'poltergeist', '1.5.0'
end

group :development, :test do
  gem 'capybara' #, '~> 2.1'
  gem 'selenium-webdriver', require: false
end

gemspec
