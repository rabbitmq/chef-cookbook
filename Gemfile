# frozen_string_literal: true
source 'https://rubygems.org'

gem 'chef'
gem 'berkshelf'
gem 'github_changelog_generator'
gem 'stove'

group :lint do
  gem 'foodcritic', '>= 12.2.1'
  gem 'cookstyle'
end

group :unit do
  gem 'chefspec'
end

group :integration do
  gem 'kitchen-inspec', '~> 1.0'
  # note: without https://github.com/inspec/train/pull/406 `kitchen verify`
  # will fail on Ruby 2.6 even with the latest version. MK.
  gem 'train', '~> 2.0'
  gem 'inspec', '~> 4.7'
end

group :kitchen_common do
  gem 'test-kitchen', '~> 2.2'
end

group :kitchen_vagrant do
  gem 'kitchen-vagrant', '~> 1.5'
end

group :kitchen_docker do
  gem 'kitchen-docker'
end

group :kitchen_dokken do
  gem 'kitchen-dokken'
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
