require 'sinatra/base'
require 'webrick'
require 'webrick/https'
require 'openssl'
require_relative './speech_server'

CERT_PATH = './'

webrick_options = {
        :Port               => 7732,
        :Logger             => WEBrick::Log::new($stderr, WEBrick::Log::DEBUG),
        :DocumentRoot       => "/ruby/htdocs",
        :SSLEnable          => true,
        :SSLVerifyClient    => OpenSSL::SSL::VERIFY_NONE,
        :SSLCertificate     => OpenSSL::X509::Certificate.new(  File.open(File.join(CERT_PATH, "server.crt")).read),
        :SSLPrivateKey      => OpenSSL::PKey::RSA.new(          File.open(File.join(CERT_PATH, "server.key")).read),
        :SSLCertName        => [ [ "CN",WEBrick::Utils::getservername , OpenSSL::ASN1::PRINTABLESTRING] ]
}


class MyServer  < Sinatra::Base

    @@server = SpeechServer.new

    get '/' do
        "hello"
    end

    post '/say' do
        headers 'Access-Control-Allow-Origin' => 'https://www.safaribooksonline.com'
        @@server.say(params["text"])
        return "ok"
    end 

    post'/pause' do
        headers 'Access-Control-Allow-Origin' => 'https://www.safaribooksonline.com'
        @@server.pause()
        return "ok"
    end

    post'/stop' do
        headers 'Access-Control-Allow-Origin' => 'https://www.safaribooksonline.com'
        @@server.stop()
        return "ok"
    end

    post '/resume' do
        headers 'Access-Control-Allow-Origin' => 'https://www.safaribooksonline.com'
        @@server.resume
        return "ok"
    end

    post '/toggle' do
        headers 'Access-Control-Allow-Origin' => 'https://www.safaribooksonline.com'
        @@server.toggle
        return "ok"
    end              
end

Rack::Handler::WEBrick.run MyServer, webrick_options