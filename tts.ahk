Ruby(params*) {
    for index,param in params
        str .= """" . param . """ "

    ; /K if you want to see the output
    Run, %comspec% /C "pushd "%A_ScriptDir%" && %str%" ,,UseErrorLevel Hide
    if ErrorLevel = ERROR  
    {
        MsgBox, Failed to run ruby %RubyPath%
        Return
    }
    Return
}

;;;;;;;;;;;;;;;;;;;;TTS;;;;;;;;;;;;;;;;;;;;;;
Gui, Add, Button, gPause, &Pause
Gui, Add, Button, gResume ys, &Resume
Gui, Add, Button, gStop ys, &Stop
Gui, Add, Button, gCloseGui ys, &Close
Gui, Add, Button, gEdit ys, &Edit
Gui, Add, Button, gSlower ys, &-
Gui, Add, Button, gFaster ys, &+
Gui, Add, Button, gReadClipboard ys, &Read
Gui, Add, Button, gStartServer ys, S&tartServer
Gui, Show,,TTS: Win + Ctrl + D


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

RunWaitOne(command) {
    ; WshShell object: http://msdn.microsoft.com/en-us/library/aew9yb99
    shell := ComObjCreate("WScript.Shell")
    ; Execute a single command via cmd.exe
    exec := shell.Exec(ComSpec " /C " command)
    ; Read and return the command's output
    return exec.StdOut.ReadAll()
}

StartServer:
    Ruby("run.rb")
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

    Ruby("rephrase_runner.rb", "c:\temp\tmp_ahk_tts_clip.txt")
Return

Stop:
    Ruby("stop.rb")
Return

Pause:
    Ruby("pause.rb")
Return

Resume:
    Ruby("resume.rb")
Return

Edit:
    Ruby("edit.bat")
Return

Faster:
    Ruby("faster.rb")
Return

Slower:
    Ruby("slower.rb")
Return

CloseGui:
    Gui, Cancel
Return

