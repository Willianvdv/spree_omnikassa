# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_omnikassa'
  s.version     = '1.2.0'
  s.summary     = 'Omnikassa payment method'
  s.required_ruby_version = '>= 1.8.7'

  s.author    = 'Pythonheads'
  s.email     = 'info@pythonheads.nl'
  s.homepage  = 'http://www.pythonheads.nl'

  s.files       = `git ls-files`.split("\n")
 
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
 
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.1.0'

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'sqlite3'
end
