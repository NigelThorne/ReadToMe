# This runs a simple sinatra app as a service

LOG_FILE = 'C:\\sinatra_daemon.log'

require 'rubygems'
require 'sinatra/base'
require './app'

#begin
  require 'win32/daemon'
  include Win32

  $stdout.reopen("thin-server.log", "w")
  $stdout.sync = true
  $stderr.reopen($stdout)

class TestDaemon < Daemon
    def service_main
      log 'started'

      MySinatraApp.run! :host => 'localhost', :port => 7732, :server => 'thin'
      while running?
        log 'running'
        sleep 10
      end
    end

    def service_stop
    log 'ended'
      exit!
    end

    def log(text)
        File.open('log.txt', 'a') { |f| f.puts "#{Time.now}: #{text}" }
    end
end

TestDaemon.mainloop
#rescue Exception => err
  #File.open(LOG_FILE,'a+'){ |f| f.puts " ***Daemon failure #{Time.now} err=#{err} " }
  #raise
#end
