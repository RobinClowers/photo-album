server 'deploy@10.0.0.2', roles: [:web, :app, :db]
server 'deploy@10.0.0.3', roles: [:app, :utility]
set :ssh_options, {keys: ['~/.vagrant.d/insecure_private_key']}
set :ssh_options, {forward_agent: true}
