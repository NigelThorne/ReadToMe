require 'uri'
require 'net/http'
#require 'openssl'
#

def say(text)
	post("say", 'text' => text)
end

def toggle()
	post("toggle", 'text' => '')
end

def pause()
   post("pause", 'text' => '')
end

def resume()
   post("resume", 'text' => '')
end

def stop()
   post("stop", 'text' => '')
end

def post(act, body)
	uri = URI.parse("http://localhost:7732/#{act}")
#	http = Net::HTTP.new(uri.host, uri.port)
#	http.use_ssl = uri.scheme == 'https'
#	http.verify_mode = OpenSSL::SSL::VERIFY_NONE
#	request = Net::HTTP::Post.new(uri.request_uri)
#	request.set_form_data(body)
#	response = http.request(request)

	response = Net::HTTP.post_form(uri, body)
end

