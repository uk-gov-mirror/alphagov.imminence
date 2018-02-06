source 'http://rubygems.org'

gem 'plek', '~> 2.1.1'

gem 'rails', '5.0.2'

gem "mongoid"
gem "mongoid_rails_migrations"

gem 'govuk_admin_template', '6.5.0'
gem 'formtastic'
gem 'formtastic-bootstrap'

gem 'gds-api-adapters', '~> 51.2.0'

if ENV['BUNDLE_DEV']
  gem 'gds-sso', path: '../gds-sso'
else
  gem 'gds-sso', '~> 13.5.1'
end

gem 'govuk_app_config', '~> 1.3'
gem "govuk_sidekiq", "~> 2.0.0"

gem 'responders', '~> 2.0'
gem 'inherited_resources'
gem 'kaminari-mongoid'
gem 'kaminari-actionview'
gem 'bootstrap-kaminari-views', '~> 0.0.3'

gem 'state_machines', '~> 0.4.0'
gem 'state_machines-mongoid', '~> 0.1.1'

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '4.1.5'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

group :development, :test do
  gem 'pry'
  gem 'govuk-lint', '3.6.0'
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'capybara'
  gem 'database_cleaner'
  gem 'simplecov', '~> 0.15.1', require: false
  gem 'simplecov-rcov', '~> 0.2.3', require: false
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'ci_reporter_minitest'
  gem 'minitest-reporters'
  gem 'launchy'
  gem 'shoulda-context'
  gem 'mocha', '~> 1.3.0', require: false
  gem 'poltergeist', '~> 1.7.0'
  gem 'webmock', '~> 3.3.0', require: false
  gem 'rails-controller-testing'
end
