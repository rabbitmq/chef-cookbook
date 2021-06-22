# frozen_string_literal: true
source 'https://rubygems.org'

gem 'chef'
gem 'berkshelf'
gem 'github_changelog_generator'
gem 'stove'

group :lint do
  gem 'foodcritic', '>= 16.3'
  gem 'cookstyle'
end

group :unit do
  gem 'chefspec'
end

group :integration do
  gem 'kitchen-inspec', '~> 2.4'
  gem 'train', '~> 3.7'
  gem 'inspec', '~> 4.37'
end

group :kitchen_common do
  gem 'test-kitchen', '~> 2.12'
end

group :kitchen_vagrant do
  gem 'kitchen-vagrant', '~> 1.8'
end

group :kitchen_docker do
  gem 'kitchen-docker'
end

group :kitchen_dokken do
  gem 'kitchen-dokken', '~> 2.13'
end

group :kitchen_cloud do
  gem 'kitchen-ec2'
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
