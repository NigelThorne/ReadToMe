# encoding: utf-8
#gem win32-clipboard 

#require 'win32/clipboard'
#include Win32

require 'win32ole'

#data = Clipboard.data


begin 

    File.open(
        File.join(
            File.dirname(__FILE__),
            "tts.pid"
        ), "w+") do |f|
        pids = f.readlines
        pids.each{|p| Process.kill(9, p.to_i) if p.to_i > 0}
        f.seek(0)
        f.write(Process.pid)    
    end

	ARGF.set_encoding(Encoding::UTF_8)
	data = ARGF.read().bytes.to_a.pack("U*")
	require_relative 'rephrase'
	text = to_speakxml(data)
	File.open('C:\\temp\\tmp_ahk_clip_out.txt',"w"){|f| 
        f.write(text)
    }
rescue => e
	text = e.message
	puts text
	gets
end

require "./say"
#WIN32OLE.new('SAPI.SpVoice').Speak(text)

say text


