source 'https://rubygems.org'
ruby '2.0.0' 

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.7'
gem 'pg', '~> 0.17.1'
gem 'bcrypt', '~> 3.1.7'

gem 'therubyracer'
gem 'twitter-bootstrap-rails', '~> 3.2.0'
gem 'less-rails'

gem 'hpricot', '0.8.6'
gem 'httparty', '0.13.1'

gem 'sidetiq', '~> 0.6.1'
gem 'sidekiq', '~> 3.1.4'
gem 'sinatra', '>= 1.3.0', :require => nil

gem 'will_paginate', '~> 3.0.7'
gem 'bootstrap-will_paginate', '~> 0.0.10'
gem 'ransack', '~> 1.4.1'
gem 'facets', '~> 2.9.3', require: false #for counting word frequency

# fix binded events problem caused by Turbolinks
gem 'jquery-turbolinks', '~> 2.1.0'

# Gems added to support Digital Ocean deployment
gem 'mina'
gem 'mina-sidekiq', :require => false
gem 'mina-unicorn', :require => false

group :development, :test do
  gem 'rspec-rails', '~> 3.1.0'
  gem 'rspec-its', '~>1.0.1'
  gem 'dotenv-rails'
end

# group :development do
#   gem 'bullet'
# end

group :test do
	gem 'selenium-webdriver', '~> 2.42.0'
	gem 'capybara', '~> 2.2.1'
	gem 'factory_girl_rails', '~> 4.4.1'
end

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.2'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :production do 
	gem 'rails_12factor', '0.0.2'
	gem 'newrelic_rpm'
end

# Use unicorn as the app server
gem 'unicorn', '~> 4.8.3'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
