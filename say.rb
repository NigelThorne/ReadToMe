require 'uri'
require 'net/http'

def say(text)
   post("say", 'text' => text)
end

def pause()
   post("pause", 'text' => '')
end

def resume()
   post("resume", 'text' => '')
end

def post(act, body)
	uri = URI.parse("http://localhost:7732/#{act}")
	response = Net::HTTP.post_form(uri, body)
end

