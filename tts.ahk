;;;;;;;;;;;;;;;;;;;;TTS;;;;;;;;;;;;;;;;;;;;;;
#^D:: ; Win + Ctrl + D 
ClipSaved := ClipboardAll   
Clipboard = ; Start off empty to allow ClipWait to detect when the text has arrived.
Send ^c
ClipWait, 0.1  ; Wait for the clipboard to contain text.
FileDelete , c:\temp\tmp_ahk_tts_clip.txt
FileAppend , %Clipboard% , c:\temp\tmp_ahk_tts_clip.txt

Gui, Add, Button, gPause, &Pause
Gui, Add, Button, gResume ys, &Resume
Gui, Add, Button, gStop ys, &Stop
Gui, Show,, TTS

Run, %comspec% /c "".\rephrase_runner.rb" c:\temp\tmp_ahk_tts_clip.txt" ,,;Hide
Clipboard := ClipSaved 
ClipSaved = ; Free the memory 
Return 

Stop:
	Run, %comspec% /c "".\stop.rb"" ,,;Hide
	Gui, Cancel
Return

Pause:
	Run, %comspec% /c "".\pause.rb"" ,,;Hide
Return

Resume:
	Run, %comspec% /c "".\resume.rb"" ,,;Hide
Return
