-- This shows me id's of all iTerm window, on all "views"
tell application "iTerm"
  set wins to id of every window whose visible is true
end tell


-- tell application "iTerm 2"
--   activate window 13195
-- end tell
