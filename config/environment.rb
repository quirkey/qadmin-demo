# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'restful_query', :version => '>=0.2.0'
  config.gem 'qadmin', :version => '>=0.2.1'
  config.gem 'rubyist-aasm', :lib => 'aasm', :source => 'http://gems.github.com'
  config.gem 'RedCloth', :version => '=4.0.4'
  config.gem 'imanip', :version => '>=0.1.4'
  config.gem 'static_model', :version => '>=0.2.0'
  config.gem 'fastercsv'
  config.gem 'will_paginate'
  config.load_paths += %W[
                          #{Rails.root}/app/mailers
                          #{Rails.root}/app/observers 
                          #{Rails.root}/app/controllers/admin
                          ]
  config.active_record.observers = :user_observer

  config.time_zone = 'UTC'

end