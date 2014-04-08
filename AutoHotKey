;;;;;;;;;;;;;;;;;;;;TTS;;;;;;;;;;;;;;;;;;;;;;
#^D:: ; Win + Ctrl + D 
ClipSaved := ClipboardAll   
Clipboard = ; Start off empty to allow ClipWait to detect when the text has arrived.
Send ^c
ClipWait  ; Wait for the clipboard to contain text.
FileDelete , c:\tmp\tmp_ahk_tts_clip.txt
FileAppend , %Clipboard% , c:\tmp\tmp_ahk_tts_clip.txt
Run, %comspec% /c ""F:\bin\tools\rephrase_runner.rb" c:\tmp\tmp_ahk_tts_clip.txt" ,,;Hide
Clipboard := ClipSaved 
ClipSaved = ; Free the memory 
return 
