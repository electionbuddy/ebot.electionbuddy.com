# frozen_string_literal: true

# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

set :application, 'ebot.electionbuddy.com'
role :app, %W[deploy@#{fetch(:application)}]
role :web, %W[deploy@#{fetch(:application)}]
role :db,  %W[deploy@#{fetch(:application)}]

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

# server 'example.com', user: 'deploy', roles: %w{web app}, my_property: :my_value

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# And/or per server (overrides global)
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }

namespace :deploy do
  task :confirmation do
    puts <<-WARN
    ========================================================================
      WARNING: You're about to deploy to the PRODUCTION server.
      Please confirm that you want to do this by answering YES.
    ========================================================================
    WARN
    ask :value, 'Are you sure you want to continue?'

    if fetch(:value) != 'YES'
      puts "\nDeploy cancelled!"
      exit
    end
  end
end

before :deploy, 'deploy:confirmation'
