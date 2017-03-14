require 'sinatra/base'
require 'rack/ssl'

class Application < Sinatra::Base
  use Rack::SSL

  configure do
    set :environment, :production
    set :server, "thin"
    set :bind, '0.0.0.0'
    set :port, 7732 #443
  end

  post '/say' do
  	puts "'SSL FTW!'"
    'SSL FTW!'
  end

  run! if app_file == $0
end