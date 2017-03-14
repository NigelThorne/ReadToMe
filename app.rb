require 'sinatra'
require_relative './speech_server'


class MySinatraApp < Sinatra::Base

  set :bind, '0.0.0.0'
  set :port, 7732 #SPEAK
  set :server, 'thin'

  @@server = SpeechServer.new

	get '/' do
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
		<button type='button' onclick=\"post('./toggle')\">Pause/Resume</button>

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
		</script>
		</body></html>"""
	end
  


	# post '/say_to_file' do
	# 	@@is_paused = false
	# 	out= voice.AudioOutputStream
	# 	temp_file = "c:\\temp\\output.wav"
	# 	rm_file(temp_file)		

	# 	fs =  WIN32OLE.new('SAPI.SpFileStream')
	# 	fs.Open(temp_file, 3, true)
	# 	puts "file open"

	# 	format_ex = WIN32OLE.new('SAPI.SpWaveFormatEx')


	# 	voice.AudioOutputStream = fs
	# 	voice.AudioOutputStream.Format.Type = 39 # SAFT48kHz16BitStereo = 39
 		
 # 		puts "stream set"

	# 	voice.Speak(params["text"], SpeechVoiceSpeakFlags::SVSFPurgeBeforeSpeak)
	# 	puts "text spoken: #{params["text"]}"
		
	# 	fs.Close()

	# 	voice.AudioOutputStream = out
	# 	puts "stream reset"

	# 	return "ok #{temp_file}"
	# end

	post '/say' do
		@@server.say(params["text"])
		return "ok"
	end	

	post'/pause' do
		@@server.pause()
		return "ok"
	end

	post'/stop' do
		@@server.stop()
		return "ok"
	end

	post '/resume' do
		@@server.resume
		return "ok"
	end

	post '/toggle' do
		@@server.toggle
		return "ok"
	end
	
	# get '/status' do
	# 	voice.Speak("status")
	# 	return "COM Object: #{@@voice.nil?}"
	# end
	


	def rm_file(file)
 		File.delete(file) if File.exist?(file)
 	end
end
