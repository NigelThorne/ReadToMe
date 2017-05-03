;;;;;;;;;;;;;;;;;;;;TTS;;;;;;;;;;;;;;;;;;;;;;
Gui, Add, Button, gPause, &Pause
Gui, Add, Button, gResume ys, &Resume
Gui, Add, Button, gStop ys, &Stop
Gui, Add, Button, gCloseGui ys, &Close
Gui, Show,, TTS


#^D:: ; Win + Ctrl + D 
    ClipSaved := ClipboardAll   
    Send ^c
    Gosub, ReadClipboard
    Clipboard := ClipSaved 
    ClipSaved = ; Free the memory 
Return 

#^S:: ; Win + Ctrl + S 
    Gosub, ReadClipboard
Return 

ReadClipboard:
    ClipWait, 2 , 1  ; Wait for the clipboard to contain text.
    if ErrorLevel
    {
        MsgBox, The attempt to copy text onto the clipboard failed.
        return
    }
    FileDelete , c:\temp\tmp_ahk_tts_clip.txt
    FileAppend , %Clipboard% , c:\temp\tmp_ahk_tts_clip.txt

    Run, %comspec% /c "".\rephrase_runner.rb" c:\temp\tmp_ahk_tts_clip.txt" ,,;Hide
Return

Stop:
    Run, %comspec% /c "".\stop.rb"" ,,;Hide
Return

Pause:
    Run, %comspec% /c "".\pause.rb"" ,,;Hide
Return

Resume:
    Run, %comspec% /c "".\resume.rb"" ,,;Hide
Return

CloseGui:
    Gui, Cancel
Return