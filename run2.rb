#!/usr/bin/env ruby
#
# This code snippet shows how to enable SSL in Sinatra.
#
require 'sinatra'
require 'thin'

class MyThinBackend < ::Thin::Backends::TcpServer
  def initialize(host, port, options)
    super(host, port)
    @ssl = true
    @ssl_options = options
  end
end


class Application < Sinatra::Base
  configure do
    set :environment, :production
    set :server, "thin"
    set :bind, '0.0.0.0'
    set :port, 7732 #443
  end

  get '/' do
    'Hello, SSL.'
  end

  post '/say' do
    puts params.inspect
  end

  def self.run!
    super do |server|
#      server.backend          = MyThinBackend
      server.ssl = true
      server.ssl_options = {
        :cert_chain_file  => File.dirname(__FILE__) + "/server.crt",
        :private_key_file => File.dirname(__FILE__) + "/server.key",
        :verify_peer      => false
      }
    end
  end

  run! if app_file == $0
end