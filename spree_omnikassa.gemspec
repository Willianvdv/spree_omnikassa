# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_omnikassa'
  s.version     = '2.2.0'
  s.summary     = 'Omnikassa payment method'
  s.required_ruby_version = '>= 1.8.7'

  s.author    = 'Willian'
  s.email     = 'mail@willian.io'
  s.homepage  = 'http://www.willian.io'

  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.3'

  s.add_development_dependency 'capybara', '~> 2.1'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'rspec-rails',  '~> 2.13'
  s.add_development_dependency 'factory_girl' #, '~> 4.2'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'coffee-rails'
end
