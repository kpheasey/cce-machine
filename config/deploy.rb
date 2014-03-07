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
  end

  after :finishing, 'deploy:cleanup'
end

after 'deploy:publishing', 'deploy:restart'

# upstart
namespace :upstart do
  desc 'Generate and upload Upstard configs for daemons needed by the app'
  task :update_configs, except: {no_release: true} do
    upstart_config_files = File.expand_path('../upstart/*.conf.erb', __FILE__)
    upstart_root         = '/etc/init'

    Dir[upstart_config_files].each do |upstart_config_file|
      config = ERB.new(IO.read(upstart_config_file)).result(binding)
      path   = "#{upstart_root}/#{File.basename upstart_config_file, '.erb'}"

      put config, path
    end
  end
end

after 'deploy:update_code', 'upstart:update_configs'

# sidekiq
namespace :sidekiq do
  desc 'Start the sidekiq workers via Upstart'
  task :start do
    sudo 'start sidekiq'
  end

  desc 'Stop the sidekiq workers via Upstart'
  task :stop do
    sudo 'stop sidekiq || true'
  end

  desc 'Restart the sidekiq workers via Upstart'
  task :restart do
    sudo 'stop sidekiq || true'
    sudo 'start sidekiq'
  end

  desc 'Quiet sidekiq (stop accepting new work)'
  task :quiet do
    pid_file       = "#{current_path}/tmp/pids/sidekiq.pid"
    sidekiqctl_cmd = 'bundle exec sidekiqctl'
    run "if [ -d #{current_path} ] && [ -f #{pid_file} ] && kill -0 `cat #{pid_file}`> /dev/null 2>&1; then cd #{current_path} && #{sidekiqctl_cmd} quiet #{pid_file} ; else echo 'Sidekiq is not running'; fi"
  end
end

before 'deploy:update_code', 'sidekiq:quiet'
after  'deploy:stop',        'sidekiq:stop'
after  'deploy:start',       'sidekiq:start'
before 'deploy:restart',     'sidekiq:restart'
