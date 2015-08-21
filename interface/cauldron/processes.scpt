tell application "System Events"
	repeat with theProcess in processes
		if not background only of theProcess then
			tell theProcess
				set processName to name
				log processName
			end tell
		end if
	end repeat
end tell

