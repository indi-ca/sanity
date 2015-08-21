on run argv
    tell application "System Events"
            tell process "Finder"
                    keystroke item 1 of argv using control down
            end tell
    end tell
end run
