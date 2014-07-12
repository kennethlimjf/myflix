source 'https://rubygems.org'
ruby '2.1.1'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'bcrypt'
gem 'fabrication'
gem 'faker'
gem 'pg'
gem 'sidekiq'
gem 'unicorn'
gem 'paratrooper'
gem 'bootstrap_form'
gem "fog", "~> 1.20", require: "fog/aws/storage"
gem 'carrierwave'
gem "mini_magick"
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'
# gem 'vcr'
# gem 'webmock'

group :development do
  gem 'sqlite3'
  gem 'pry'
  gem 'pry-nav'
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'letter_opener'
end

group :development, :test do
  gem 'rspec-rails', '= 2.99'
  gem 'shoulda-matchers', require: false
  gem 'capybara'
  gem 'launchy'
  gem 'capybara-email'
end

group :test do
  gem 'database_cleaner', '1.2.0'
end

group :production do
  gem 'rails_12factor'
  gem "sentry-raven"
end
