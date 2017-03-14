# config.ru
require 'rubygems'
require 'sinatra'
require 'rack/reloader'
require './app'

set :environment, :development


use Rack::Reloader, 0 if development?
run Sinatra::Application
