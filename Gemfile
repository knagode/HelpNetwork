source 'https://rubygems.org'
ruby '2.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.4'


# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# state of the art hash function  to irreversibly encrypt the password to form the password hash
gem 'bcrypt', '~> 3.1.7', require: "bcrypt"

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

gem 'fontello_rails_converter'

gem 'bootstrap-sass'

gem "haml-rails"

gem 'simple_form', '~> 3.0.2'

gem 'm3_table_admin', :git => "git://github.com/mice3/M3TableAdmin.git"

gem "paperclip"


group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem "better_errors" # better errors display
  gem 'quiet_assets' # quite noisy asset logging

  gem "binding_of_caller" #display private instance variable errors
  gem 'sqlite3'
end

group :test do
  gem 'rspec-rails', '~> 3.0.1' # testing framework
  gem 'ruby-prof', '~> 0.15.1' #testing parts of code inside code
  gem 'capybara', '~> 2.3.0' # testing features (virtual browser)
  gem 'poltergeist', '~> 1.5.1'#Poltergeist is a driver for Capybara that allows you to run your tests on a headless WebKit browser, provided by PhantomJS.

  gem 'factory_girl_rails', '4.4.1' #A better and more convenient way to define user objects and insert them in the database. All defined in the file spec/factories.rb
  gem 'spork-rails', '~> 4.0.0'
  gem 'guard-spork', '1.5.0'
  gem 'childprocess', '0.3.6'

  gem 'simplecov', '~> 0.8.2', :require => false #code coverage
  gem 'sqlite3'
end

group :production do
  gem 'rails_12factor', '0.0.2' #needed for heroku
  # gem 'rails_serve_static_assets'
  gem 'pg'
end

# Custom settings
gem "choices", "0.3.2"

# OAuth authentication providers.
gem 'omniauth-facebook', '~> 1.6.0'
gem 'omniauth-google-oauth2', '~> 0.2.4'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

