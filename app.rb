require 'sinatra'
require 'win32ole'
Sinatra::Application.reset! 

class MySinatraApp < Sinatra::Base

  set :port, 7732 #SPEAK
  
  module SpeechVoiceSpeakFlags
    #SpVoice Flags
    SVSFDefault = 0
    SVSFlagsAsync = 1
    SVSFPurgeBeforeSpeak = 2
    SVSFIsFilename = 4
    SVSFIsXML = 8
    SVSFIsNotXML = 16
    SVSFPersistXML = 32

    #Normalizer Flags
    SVSFNLPSpeakPunc = 64

    #Masks
    SVSFNLPMask = 64
    SVSFVoiceMask = 127
    SVSFUnusedFlags = -128
  end
  
  @@queue ||= []

	post '/say' do
		voice.Speak(params["text"], SpeechVoiceSpeakFlags::SVSFlagsAsync)
		return "ok"
	end

	post '/say_to_file' do
		out= voice.AudioOutputStream
		temp_file = "c:\\temp\\output.wav"
		rm_file(temp_file)		

		fs =  WIN32OLE.new('SAPI.SpFileStream')
		fs.Open(temp_file, 3, true)
		puts "file open"

		format_ex = WIN32OLE.new('SAPI.SpWaveFormatEx')


		voice.AudioOutputStream = fs
		voice.AudioOutputStream.Format.Type = 39 # SAFT48kHz16BitStereo = 39
 		
 		puts "stream set"

		voice.Speak(params["text"], SpeechVoiceSpeakFlags::SVSFPurgeBeforeSpeak)
		puts "text spoken: #{params["text"]}"
		
		fs.Close()

		voice.AudioOutputStream = out
		puts "stream reset"

		return "ok #{temp_file}"
	end


	post'/pause' do
		voice.Pause
		return "ok"
	end

	post '/resume' do
		voice.Resume
		return "ok"
	end
	
	get '/status' do
		voice.Speak("status")
		return "COM Object: #{@@voice.nil?}"
	end
	
	def voice
		begin 
			@@voice.IsUISupported(nil) if(@@voice != nil) 
		rescue
			@@voice = nil
		end
		@@voice ||= WIN32OLE.new('SAPI.SpVoice')
	end

	def rm_file(file)
 		File.delete(file) if File.exist?(file)
 	end
end
