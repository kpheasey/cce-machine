source 'https://rubygems.org'

# Rails
gem 'rails', '4.0.3'

# PostrgeSQL DBMS
gem 'pg'

# JS, CSS and HTML gems
gem 'haml', '~> 4.0.4'
gem 'sass-rails', '~> 4.0.1'
gem 'bootstrap-sass', '~> 3.1.1.0'
gem 'jquery-rails', '~> 3.0.4'
gem 'jbuilder', '~> 1.0.2'
gem 'uglifier', '~> 2.1.1'

# date time picker
gem 'momentjs-rails', '~> 2.5.0'
gem 'bootstrap3-datetimepicker-rails', '~> 2.1.30'

# BTC Market APIs
gem 'btce', '~> 0.5.0'
gem 'mtgox', '~> 1.1.0'
gem 'cryptsy-api', github: 'kpheasey/cryptsy-api'

# General gems
gem 'activeadmin', github: 'gregbell/active_admin'
gem 'devise', '~> 3.2.2'
gem 'friendly_id', '~> 5.0.0'
gem 'pjax_rails', '~> 0.4.0'
gem 'puma'
gem 'sidekiq', '~> 2.17.4'
gem 'whenever', require: false

# deployments
group :development do
  gem 'capistrano', '~> 3.1'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-rvm'
end

# debugging
group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'debugger'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end
