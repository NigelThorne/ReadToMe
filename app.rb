require 'sinatra'
require 'win32ole'

@@voice ||= WIN32OLE.new('SAPI.SpVoice')

set :port, 77325 #SPEAK

post '/say' do
    @@voice.Speak(params["text"], 3)
	return "ok"
end

post'/pause' do
    @@voice.Pause
	return "ok"
end

post '/resume' do
	@@voice.Resume
	return "ok"
end