# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

# Includes tasks from other gems included in your Gemfile
require 'capistrano/rvm'
#require 'capistrano/rbenv'
#require 'capistrano/chruby'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'sidekiq/capistrano'
require 'whenever/capistrano'
require 'new_relic/recipes'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

SSHKit.config.command_map[:whenever] = 'bundle exec whenever'
