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

    on roles(:ticker), in: :sequence, wait: 5 do
      # restart sidekiq daemon
      execute 'sudo stop sidekiq'
      execute 'sudo start sidekiq'
    end
  end

  after :finishing, 'deploy:cleanup'
end

# restart actions
after 'deploy:publishing', 'deploy:restart'
