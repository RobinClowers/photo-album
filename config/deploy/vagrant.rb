server 'deploy@10.0.0.2', roles: [:app]
set :ssh_options, {keys: ['~/.vagrant.d/insecure_private_key']}
set :ssh_options, {forward_agent: true}
