tell application "System Events"
    set this_info to {}
    repeat with theProcess in (application processes where visible is true)
        set this_info to this_info & (value of (first attribute whose name is "AXWindows") of theProcess)
        set this_info to this_info & "!"
    end repeat
    this_info -- display list in results window of AppleScript Editor
end tell
