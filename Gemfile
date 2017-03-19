# frozen_string_literal: true
source 'https://rubygems.org'

gem 'chef'
gem 'chefspec'
gem 'github_changelog_generator'
gem 'kitchen-digitalocean'
gem 'stove'
gem 'kitchen-dokken'

group :lint do
  gem 'foodcritic'
  gem 'rubocop'
  gem 'rainbow'
  gem 'cookstyle'
end

group :unit do
  gem 'berkshelf'
  gem 'fauxhai'
end

group :kitchen_common do
  gem 'test-kitchen'
end

group :kitchen_vagrant do
  gem 'kitchen-vagrant'
end

group :kitchen_docker do
  gem 'kitchen-docker'
end

group :kitchen_cloud do
  gem 'kitchen-ec2'
  gem 'kitchen-openstack'
end

group :development do
  gem 'ruby_gntp'
  gem 'growl'
  gem 'rb-fsevent'
  gem 'guard'
  gem 'guard-kitchen'
  gem 'guard-foodcritic'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'rake'
end
