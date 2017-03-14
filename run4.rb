require 'sinatra/base'
require 'webrick'
require 'webrick/https'
require 'openssl'

class MyServer  < Sinatra::Base
    post '/say' do
      puts params.inspect
      ""
    end            
end

CERT_PATH = '.'

webrick_options = {
  :Port               => 7732,
  :Logger             => WEBrick::Log::new($stderr, WEBrick::Log::DEBUG),
  :DocumentRoot       => "/ruby/htdocs",
  :SSLEnable          => true,
  :SSLVerifyClient    => OpenSSL::SSL::VERIFY_NONE,
  :SSLCertificate     => OpenSSL::X509::Certificate.new(  File.open(File.join(CERT_PATH, "server.crt")).read),
  :SSLPrivateKey      => OpenSSL::PKey::RSA.new(          File.open(File.join(CERT_PATH, "server.key")).read),
  :SSLCertName        => [ [ "CN",WEBrick::Utils::getservername ] ],
  :app                => MyServer
}
Rack::Server.start webrick_options