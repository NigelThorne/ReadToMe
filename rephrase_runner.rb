# encoding: utf-8
require 'win32ole'
require "./say"

begin
	text = File.read('c:\\temp\\tmp_ahk_tts_clip.txt')
#	ARGF.set_encoding(Encoding::UTF_8)
#	text = ARGF.read();
	data = text.bytes.to_a.pack("U*")
	require_relative 'rephrase'
	text = to_speakxml(data)
	File.open('C:\\temp\\tmp_ahk_clip_out.txt',"w"){|f|
        f.write(text)
    }
  say text
rescue => e
	text = e.message
	text = "empty message" if text.empty?
  	WIN32OLE.new('SAPI.SpVoice').Speak(text)
end
