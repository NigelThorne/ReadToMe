require './app.rb'

MySinatraApp.run! :host => 'localhost', :port => 7732, :server => 'thin'

#MySinatraApp.run!(:host => 'localhost', :port => 7732, :server => 'thin') do |server|
#  ssl_options = {
#        :cert_chain_file  => File.dirname(__FILE__) + "/server.crt",
#        :private_key_file => File.dirname(__FILE__) + "/server.key",
#        :verify_peer => false
#  }
#  server.ssl = true
#  server.ssl_options = ssl_options
#end