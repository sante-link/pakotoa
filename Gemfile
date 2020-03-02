source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.2', '>= 6.0.2.1'
# Use PostgreSQL as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Application gems
gem 'jquery-rails'
# Use devise for users authentication
gem 'devise'

# Use cancan to check users permissions
gem 'cancancan'

# Write views in HAML
gem 'haml-rails'

# Use omniauth to authenticate users against out OAuth2 provider
gem 'omniauth'

# Use our custom Medispo omniauth strategy
# gem 'omniauth-medispo', git: 'ssh://git@dev.medispo.fr/sante-link/medispo/omniauth-medispo.git'

gem 'acts_as_list'

gem 'jquery-ui-rails'

gem 'simple_form'

gem 'show_for'

gem 'exception_notification'

gem 'grape'
gem 'grape-swagger'
gem 'swagger-ui_rails'

# Webrick if buggy.
gem 'thin', group: :development

gem 'chronic'

gem 'bootstrap-sass'
gem 'font-awesome-rails'

gem 'responders'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem "rubocop"
  gem "rubocop-performance"
  gem "rubocop-rspec"
  gem "rubocop-rails"
  gem "rubocop-rails_config"
  gem "haml_lint", require: false
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :test do
  # Rspec (use only "rspec-rails" once RSpec 4 is out.)
  %w[rspec-core rspec-expectations rspec-mocks rspec-rails rspec-support].each do |lib|
    gem lib, git: "https://github.com/rspec/#{lib}.git", branch: 'master'
  end
  gem 'database_cleaner'
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'capybara-screenshot'
  gem 'poltergeist'
  gem 'cucumber-rails', require: false
  gem 'factory_bot_rails'
  gem 'spring-commands-cucumber'
  gem 'spring-commands-rspec'
  gem 'simplecov', require: false
  gem 'timecop'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
