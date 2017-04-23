# frozen_string_literal: true
source 'https://rubygems.org'

gem 'chef'
gem 'berkshelf'
gem 'github_changelog_generator'
gem 'stove'

group :lint do
  gem 'foodcritic'
  gem 'cookstyle'
end

group :unit do
  gem 'chefspec'
end

group :integration do
  gem 'inspec'
end

group :kitchen_common do
  gem 'test-kitchen'
end

group :kitchen_vagrant do
  gem 'kitchen-vagrant'
end

group :kitchen_dokken do
  gem 'kitchen-dokken'
end

group :kitchen_cloud do
  gem 'kitchen-ec2'
  gem 'kitchen-openstack'
  gem 'kitchen-digitalocean'
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
