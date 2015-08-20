tell application "System Events"
	repeat with theProcess in processes
		if not background only of theProcess then
			tell theProcess
				set processName to name
                set theWindows to windows
				log processName
			end tell
            set windowsCount to count of theWindows

            if windowsCount is greater than 0 then
                repeat with theWindow in theWindows
                    set windowName to name
                    set window_info to (value of (first attribute whose name is "AXWindows") of theProcess)
                    set print to window_info as text
                    -- log "Window: " & window_info
                end repeat
            end if

		end if
	end repeat
end tell

