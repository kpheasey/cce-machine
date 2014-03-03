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
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      #within release_path do
      #   execute :rake, 'cache:clear'
      #end
    end
  end

  after :finishing, 'deploy:cleanup'

end

# restart Passenger
after 'deploy:publishing', 'deploy:restart'

# Rake tasks


# handle stream daemons
namespace :daemons do

  desc 'Stop Rails daemons'
  task :stop do
    run("cd #{deploy_to}/current; /usr/bin/env rake daemons:stop RAILS_ENV=#{rails_env}")
  end

  task :start do
    run("cd #{deploy_to}/current; /usr/bin/env rake daemons:start RAILS_ENV=#{rails_env}")
  end

  task :restart do
    run("cd #{deploy_to}/current; /usr/bin/env rake daemons:restart RAILS_ENV=#{rails_env}")
  end
end
after 'deploy:stop',    'daemons:stop'
after 'deploy:start',   'daemons:start'
after 'deploy:restart', 'daemons:restart'

