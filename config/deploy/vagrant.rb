server 'vagrant@10.0.0.2', roles: [:app]
set :ssh_options, {keys: ['~/.vagrant.d/insecure_private_key']}
