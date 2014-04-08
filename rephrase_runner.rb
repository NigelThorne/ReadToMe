# encoding: utf-8
#gem win32-clipboard 

#require 'win32/clipboard'
#include Win32

require 'win32ole'

#data = Clipboard.data

begin 
	ARGF.set_encoding(Encoding::UTF_8)
	data = ARGF.read().bytes.to_a.pack("U*")
	require_relative 'rephrase'
	text = to_speakxml(data)
	File.open('C:\\tmp\\tmp_ahk_clip_out.txt',"w"){|f| f.write(text)}
rescue => e
	text = e.message
	puts text
	gets
end


WIN32OLE.new('SAPI.SpVoice').Speak(text)



