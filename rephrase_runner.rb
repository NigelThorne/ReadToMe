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
  	WIN32OLE.new('SAPI.SpVoice').Speak(text)
end
