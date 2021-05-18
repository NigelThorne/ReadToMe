# encoding: utf-8
begin

	require 'win32ole'
	require "./say"

	text = File.read('c:\\temp\\tmp_ahk_tts_clip.txt')
#	ARGF.set_encoding(Encoding::UTF_8)
#	text = ARGF.read();
	data = text.bytes.to_a.pack("U*")
	require_relative 'rephrase'
	if data == ""
		toggle
	else
		text = to_speakxml(data)
		File.write('C:\\temp\\tmp_ahk_clip_out.txt',text)
		say text
	end
rescue => e
	text = e.message
	text = "empty message" if text.empty?
	puts text

	if text =~ /Failed to open TCP connection/
		io = IO.popen("ruby run.rb")
		io2 = IO.popen("ruby rephrase_runner.rb")
	else
		WIN32OLE.new('SAPI.SpVoice').Speak(text)
	end
end
