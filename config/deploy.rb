# frozen_string_literal: true

set :ssh_options, forward_agent: true, user: ENV['USER']

set :branch, ENV['BRANCH'] if ENV['BRANCH']

# All these set's need lambda's as :application is defined in {stage}.rb.
set :repo_url, -> { 'git@github.com:electionbuddy/ebot.electionbuddy.com.git' }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, -> { "/var/hubot/#{fetch(:application)}" }
