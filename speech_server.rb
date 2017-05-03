require 'win32ole'

class SpeechServer

  def initialize   
   @is_paused = false
   @queue ||= []
  end
  
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

  def say(text)
  	@is_paused = false
  	voice.Speak(text, SpeechVoiceSpeakFlags::SVSFIsXML)
  end

  def pause
  	voice.Pause
  	@is_paused = true
  end

  def stop
  	voice.Speak("", SpeechVoiceSpeakFlags::SVSFPurgeBeforeSpeak)
  	@is_paused = false
  end

  def resume
  	voice.Resume
  	@is_paused = false
  end

  def toggle
  	if (@is_paused)
			@is_paused = false
			voice.Resume
		else	
			@is_paused = true
			voice.Pause
		end
	end

	def voice
		begin 
			@@voice.IsUISupported(nil) if(@@voice != nil) 
		rescue
			@@voice = nil
		end
		@@voice ||= WIN32OLE.new('SAPI.SpVoice')
	end
  
end