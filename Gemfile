# frozen_string_literal: true
source 'https://rubygems.org'

gem 'chef'
gem 'chefspec'
gem 'github_changelog_generator'
gem 'kitchen-digitalocean'
gem 'kitchen-dokken'
gem 'stove'

group :lint do
  gem 'cookstyle'
  gem 'foodcritic'
  gem 'rainbow'
  gem 'rubocop'
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
  gem 'growl'
  gem 'guard'
  gem 'guard-foodcritic'
  gem 'guard-kitchen'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'rake'
  gem 'rb-fsevent'
  gem 'ruby_gntp'
end
