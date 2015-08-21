on run argv
    set theTitle to (item 1 of argv)
    tell application "System Events"
        set theProcesses to application processes
        repeat with theProcess from 1 to count theProcesses
            set theName to (name of process theProcess)
            if theName contains "Sublime Text"
                tell process theProcess
                    repeat with x from 1 to (count windows)
                        set windowName to (name of window x)
                        if windowName contains theTitle
                            try
                                click menu item (name of window x) of menu of menu bar item "Window" of menu bar 1
                            end try
                            do shell script "open -a 'Sublime Text'"
                        end if
                    end repeat
                end tell
            end if
        end repeat
    end tell
end run
