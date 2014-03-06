set :stage, :production
set :branch, 'master'
server '107.170.63.239:10420', user: 'deploy', roles: %w{web app db ticker}