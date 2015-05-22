source 'http://ruby.taobao.org'

gem 'rails', '4.2.1'

# db
gem 'mysql2'

# assets
gem 'sass-rails', '~> 4.0.3'
gem 'twitter-bootstrap-rails', '~> 3.2.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'

# pic uploading
# gem 'carrierwave'
# 为了能一次添加多个图片，所以用这个版本
gem 'carrierwave', github:'carrierwaveuploader/carrierwave', ref: '01f7ec68d0403dfeec13e5f177ffa7e272b230aa'
gem 'carrierwave-qiniu'
gem 'qiniu-rs'
gem 'mini_magick'

# view
gem 'kaminari'
gem 'kaminari-bootstrap', '~> 3.0.1'
gem 'slim-rails'
gem 'simple_form'

# background processing
gem 'sidekiq'
gem 'sinatra', :require => false

# others
gem 'jbuilder', '~> 2.0'
gem 'devise', '~> 3.4.0'
gem 'mongoid'
gem 'aasm'
gem 'settingslogic'
gem 'cancan'
gem 'rest-client'
gem 'acts-as-taggable-on', '~> 3.4'
gem 'colorize'

group :development, :test do
  gem 'thin'
  gem 'spring'
  gem "spring-commands-rspec"
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'http_logger'
  gem 'pry'
  gem 'pry-rails'
  gem 'awesome_print'
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'meta_request'
  gem 'binding_of_caller'
  gem 'letter_opener'
  gem 'byebug'
end


# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
gem 'unicorn'

# monitor
gem 'newrelic_rpm'
gem 'slack-notifier'
gem 'exception_notification', '~> 4.0.1'

#api
gem 'grape'
gem 'grape-entity'
gem 'grape-jbuilder'
gem 'swagger-ui_rails'
gem 'grape-swagger-rails'
gem 'rack-cors'
gem 'jwt'

# deployment
group :development do
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano3-unicorn'
end
