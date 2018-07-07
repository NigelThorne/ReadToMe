require 'sinatra'
require 'win32ole'
#Sinatra::Application.reset!
require 'tempfile'




class MySinatraApp < Sinatra::Base

  set :port, 7732 #SPEAK
  set :bind, '0.0.0.0'

  @@is_paused = false

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

	get '/' do
		voice
		"""<html><body>
		<script src=\"https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js\"></script>
		<script>
		function post(link) {
		  var xhttp = new XMLHttpRequest();
		  xhttp.open(\"POST\", link , true);
		  xhttp.send();
		}
		</script>

		<form id='sayform' action='./say' method='post'>What should I say?: <input name='text' type='text'></input></form></br>
		<button type='button' onclick=\"post('./pause')\">Pause</button>
		<button type='button' onclick=\"post('./resume')\">Resume</button>
		<button type='button' onclick=\"post('./stop')\">Stop</button>
		<button type='button' onclick=\"post('./toggle')\">Toggle Pause</button>
		<button type='button' onclick=\"post('./faster')\">Faster</button>
		<span>#{@@rate}</span>
		<button type='button' onclick=\"post('./slower')\">Slower</button>
		<button id='saytofile' type='button'>say_to_file</button>

		<script>
			$('#sayform').submit(function(e){
			    e.preventDefault();
			    $.ajax({
			        url:'./say',
			        type:'post',
			        data:$('#sayform').serialize(),
			        success:function(){
			        	$('#sayform input').val(\"\");
			        }
			    });
			});
			$('#saytofile').click(function(e){
			    e.preventDefault();
			    $.ajax({
			        url:'./say_to_file',
			        type:'post',
			        data:$('#sayform').serialize(),
			        success:function(){
			        	$('#sayform input').val(\"\");
			        }
			    });
			});
		</script>
		</body></html>"""
	end

	post '/say' do
		@@is_paused = false
		voice.Speak(params["text"], SpeechVoiceSpeakFlags::SVSFlagsAsync)
		return "ok"
	end

	post '/say_to_file' do
		@@is_paused = false
		out= voice.AudioOutputStream
		temp_file = "c:\\temp\\output.wav"
		rm_file(temp_file)

		fs =  WIN32OLE.new('SAPI.SpFileStream')
		fs.Format.Type = 39 # SAFT48kHz16BitStereo = 39
		fs.Open(temp_file, 3, true)
		puts "file  open #{temp_file}"

		#format_ex = WIN32OLE.new('SAPI.SpWaveFormatEx')


		voice.AudioOutputStream = fs

 		puts "stream set"

		voice.Speak(params["text"], 3)
		puts "text spoken: #{params["text"]}"
		voice.WaitUntilDone(-1)
		fs.Close()

		voice.AudioOutputStream = out
		puts "stream reset"

		return "ok #{temp_file}"
	end

	post'/pause' do
		voice.Pause
		@@is_paused = true
		return "ok"
	end

	post'/stop' do
		voice.Speak("", SpeechVoiceSpeakFlags::SVSFPurgeBeforeSpeak)
		@@is_paused = false
		return "ok"
	end

	post '/resume' do
		voice.Resume
		@@is_paused = false
		return "ok"
	end

	post '/faster' do
		@@rate = @@rate + params["amount"].to_i
		voice.Rate = @@rate
		return "ok"
	end

	post '/slower' do
		@@rate = @@rate - params["amount"].to_i
		voice.Rate = @@rate
		return "ok"
	end

	post '/toggle' do
		if (@@is_paused)
			@@is_paused = false
			voice.Resume
		else
			@@is_paused = true
			voice.Pause
		end
		return "ok"
	end

	get '/status' do
		voice.Speak("status")
		return "COM Object: #{@@voice.nil?}"
	end

	get '/save' do
		file = Tempfile.new('tts')
		path = file.path      # => A unique filename in the OS's temp directory,
		               #    e.g.: "/tmp/foo.24722.0"
		               #    This filename contains 'foo' in its basename.
		file.close
		stream = WIN32OLE.new("SAPI.SpFileStream")
		stream.Format.Type = 39 # SAFT48kHz16BitStereo
		stream.Open path, 3 # SSFMCreateForWrite
		voice.AudioOutputStream = stream
		voice.Speak
	end

	def voice
		begin
			@@voice.IsUISupported(nil) if(@@voice != nil)
		rescue
			@@voice = nil
		end
		if(@@voice == nil)
			@@voice = WIN32OLE.new('SAPI.SpVoice')
			@@rate  = @@voice.Rate()
		end
		@@voice
	end

	def rm_file(file)
 		File.delete(file) if File.exist?(file)
 	end
end
