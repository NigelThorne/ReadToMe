Ruby(params*) {
    for index,param in params
        str .= """" . param . """ "

    Run, %comspec% /c ""ruby" %str%" ,,;Hide
    Return
}

;;;;;;;;;;;;;;;;;;;;TTS;;;;;;;;;;;;;;;;;;;;;;
Gui, Add, Button, gPause, &Pause
Gui, Add, Button, gResume ys, &Resume
Gui, Add, Button, gStop ys, &Stop
Gui, Add, Button, gCloseGui ys, &Close
Gui, Add, Button, gEdit ys, &Edit
Gui, Add, Button, gSlower ys, &Slower
Gui, Add, Button, gFaster ys, &Faster
Gui, Add, Button, gReadClipboard ys, &Read
Gui, Show,,


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

    Ruby(".\rephrase_runner.rb", "c:\temp\tmp_ahk_tts_clip.txt")
Return

Stop:
    Ruby(".\stop.rb")
Return

Pause:
    Ruby(".\pause.rb")
Return

Resume:
    Ruby(".\resume.rb")
Return

Edit:
    Ruby(".\rephrase.rb")
Return

Faster:
    Ruby(".\faster.rb")
Return

Slower:
    Ruby(".\slower.rb")
Return

CloseGui:
    Gui, Cancel
Return

