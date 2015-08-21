tell application "Script Editor"
    set index of window 2 to 1
end tell
tell application "System Events" to tell process "Script Editor"
    perform action "AXRaise" of window 2
end tell
