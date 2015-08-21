on raiseWindow()

tell application "System Events"
    set theProcesses to application processes
    repeat with theProcess from 1 to count theProcesses
        set theName to (name of process theProcess)
        if theName contains "Lime"
            tell process theProcess
                repeat with x from 1 to (count windows)
                    set windowName to (name of window x)
                    --try
                    --    click menu item (name of window x) of menu of menu bar item "Window" of menu bar 1
                    --end try
                    -- return 0
                    set index of window 1 to 1
                    perform action "AXRaise" of window x
                    log windowName
                    log x
                end repeat
            end tell
        end if
    end repeat
end tell

end raiseWindow


raiseWindow()

