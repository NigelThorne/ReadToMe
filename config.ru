# config.ru
require 'bundler/setup'
require_relative './app'
# require 'main'



run Sinatra::Application

# require 'rack/reloader'

# set :environment, :development


# use Rack::Reloader, 0 if development?
#run Sinatra::Application
