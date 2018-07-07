require './app.rb'

MySinatraApp.run! :host => 'localhost', :port => 7732, :server => 'thin',  :bind => '0.0.0.0'
