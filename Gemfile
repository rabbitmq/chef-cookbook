# frozen_string_literal: true
source 'https://rubygems.org'

gem 'chef'
gem 'berkshelf'
gem 'github_changelog_generator'
gem 'nokogiri', ">= 1.13.4"
# Pinned to the highest version compatible with chef-cli's `< 2.9` constraint.
# Contains the partial fix for CVE-2026-35611 (ReDoS in URI templates).
# Drop this pin once chef-cli relaxes the constraint and addressable >= 2.9.0 can be used.
gem 'addressable', '>= 2.8.10', '< 2.9'
# Drop this pin once all transitive consumers allow >= 2.14.1.
gem 'faraday', '>= 1.10.5'
gem 'stove'

group :lint do
  gem 'cookstyle'
end

group :unit do
  gem 'chefspec'
end

group :integration do
  gem 'kitchen-inspec', '~> 2.4'
  gem 'train', '~> 3.7'
  gem 'inspec', '~> 5.22'
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
