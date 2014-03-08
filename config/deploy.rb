set :application, 'cce-machine'
set :repo_url, 'git@github.com:kpheasey/cce-machine.git'

set :deploy_to, '/var/www/ccemachine.com'
set :scm, :git

set :format, :pretty
set :log_level, :debug
set :pty, true

set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :default_env, { path: '/opt/ruby/bin:$PATH' }
set :keep_releases, 5

set :sidekiq_cmd, 'sudo start sidekiq'
set :sidekiq_pid, "#{current_path}/tmp/pids/sidekiq.pid"

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # restart Passenger
      execute :touch, release_path.join('tmp/restart.txt')

      # restart daemons
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'daemons:stop'
          execute :rake, 'daemons:start'
        end
      end
    end
  end

  desc 'Inform newrelic of deployment'
  task :inform_newrelic do
    on roles(:app) do
      execute 'curl -H "x-api-key:ff7372426bf76f9341d93af73f3913b956da14b72f4ee6d" -d "deployment[app_name]=CCE Machine" https://api.newrelic.com/deployments.xml'
    end
  end

  after :finishing, 'deploy:cleanup'
end

after 'deploy:publishing', 'deploy:restart'
after 'deploy:finishing', 'deploy:inform_newrelic'