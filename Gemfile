# frozen_string_literal: true

source "https://rubygems.org"

gem "bcrypt", "~> 3.1.7"
gem "bootsnap", require: false
gem "jwt"
gem "pagy"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "rails", "~> 7.2.2"
gem "redis"
gem "sprockets-rails"
gem "tzinfo-data", platforms: %i[windows jruby]

# BackgroundJob and Scheduling
gem "sidekiq"
gem "sidekiq-scheduler"

# Grape
gem "grape"
gem "grape-entity"
gem "grape-swagger"
gem "grape-swagger-entity"
gem "grape-swagger-rails"

# Performance and Error Tracking
gem "rollbar"
gem "scout_apm"

group :development, :test do
  gem "byebug"
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "dotenv-rails"

  # Code Quality & Linting
  gem "rubocop-rails-suite", require: false

  # Rspec
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails", "~> 7.0.0"

  # Security
  gem "brakeman", require: false
  gem "bundler-audit", require: false
end

group :development do
  # Performance
  gem "bullet"
end

group :test do
  gem "rspec-sidekiq"
  gem "shoulda-matchers"
  gem "simplecov", require: false
end
