source 'https://rubygems.org'

ruby '2.4.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.8'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# will paginate for pagination
gem 'will_paginate'

gem 'activeadmin', :git => 'https://github.com/activeadmin/activeadmin'

gem 'tolk'

gem 'activeadmin_addons'

gem 'active_admin-acts_as_list'

gem 'active_skin'

gem "font-awesome-rails"

gem 'bootstrap-tooltip-rails'

gem 'bootstrap-sass'

gem 'awesome_nested_set'

gem "remotipart", "~> 1.2"

gem 'bootstrap-datepicker-rails'

# Expect MySQL as main database
gem 'mysql2'

# Use unicorn as the app server
gem 'unicorn'

gem 'whenever', require: false

# Async process
gem 'sidekiq'

# Redis
gem 'redis-rails'

gem 'redis-namespace'

# Environment specific setting
gem 'config'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Bulk Insert / Update
gem 'upsert'

# Soft deletion - for Rails 4, need to use version 2
gem 'paranoia', '~> 2.0'

# Hierarchical data
gem 'ancestry'

# delayed_paperclip
gem 'delayed_paperclip'

# Process attachiment
gem 'paperclip', '4.2.0'

gem 'cocaine', '0.5.4'

# Media handling by paperclip via ffmpeg
gem 'paperclip-ffmpeg'

# Media metadata
gem 'streamio-ffmpeg'

# Data seeding
gem 'seedbank'

# Pagination
gem 'kaminari'

# XML
gem 'nokogiri'

# CSV
gem 'comma'

gem "haml", '~> 4.0.6'

# Haml scaffolding functions
gem 'haml-rails', '~> 0.9.0', :group => :development
# gem 'bullet', group: 'development'

# Authentication
gem 'devise'

# Authorization
gem 'cancancan'

# Omniauth
gem 'omniauth'

# Console
gem 'awesome_print'

# External Http request.
gem 'rest-client', :git =>'https://github.com/rest-client/rest-client.git'

# Get File Properties
gem 'ruby-filemagic'

# Browser detection
gem 'useragent'

#bundle exec figaro heroku:set --app test-staging -e production
gem "figaro"

gem 'friendly_id'

gem 'mail'

gem 'valid_email'

# shows maintenance page (public/maintenance.html if exists)
gem 'rack-maintenance'

gem 'pdfkit'

gem 'wicked_pdf'

gem 'wkhtmltopdf-binary-edge'

gem "cocoon"

gem 'time_difference'

gem 'ckeditor_rails'

gem 'descriptive_statistics', '~> 2.4.0', :require => 'descriptive_statistics/safe'

gem "i18n-js"

gem "roo", "~> 2.7.0"

gem 'formvalidation-rails'

group :production do
  gem 'exception_notification'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and
  # get a debugger console
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'pry-doc'
  gem 'pry-stack_explorer'  
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or
  # by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'thin'
  gem 'quiet_assets'
  gem 'better_errors'
  # rspec command for Spring
  #gem 'spring-commands-rspec'
end

group :developemnt, :test do
  gem 'ruby-prof'
  # Use Rspec instead of Test::Unit
  gem 'rspec-rails'
  # Watch file modifications
  gem 'guard'
  # Rspec guard support
  gem 'guard-rspec'
  # Watch coding guidline violations and unit test failures on file modification
  gem 'guard-rubocop'
  # Notify if violations or failures happen
  gem 'terminal-notifier-guard'
  # Fixture
  gem 'factory_girl_rails'
  # Randam data
  gem 'ffaker'
  # Ensure a clean state during tests
  gem 'database_cleaner'
  # Coveralls
  gem 'coveralls', :require => false
end

group :test do
  gem 'webmock'
  gem 'mock_redis'
  gem 'rspec-sidekiq'
  gem 'zeus'
end

# Use Capistrano for deployment
group :deployment do
  gem 'capistrano', '~> 2.15.5'
  gem 'capistrano_colors'
  gem 'capistrano-ext'
  gem 'capistrano-sidekiq'
  gem 'capistrano-rbenv'
end

