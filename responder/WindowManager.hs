module WindowManager (perform) where


import System.IO (hPutStrLn, Handle)
import Desktop (activate, switchDesktop, sublime)


perform :: String -> Handle -> IO ()
perform "xping" handle = hPutStrLn handle "xpong\r\n"
perform "ping" handle = hPutStrLn handle "pong\r\n"

perform "a" handle = do
  activate "AppCode"
  hPutStrLn handle "OK\r\n"
perform "c" handle = do
  activate "Google Chrome"
  hPutStrLn handle "OK\r\n"
perform "e" handle = do
  activate "Emacs"
  hPutStrLn handle "OK\r\n"
perform "s" handle = do
  activate "Sublime Text"
  hPutStrLn handle "OK\r\n"

perform "F1" handle = do
    activate "iTerm"
    return ()
perform "F2" handle = do
    sublime
    return ()
perform "F3" handle = do
    switchDesktop 3
    activate "Slack"
    return ()
perform "CMD-F3" handle = do
    switchDesktop 3
    activate "LimeChat"
    return ()
perform "F4" handle = do
    activate "Google Chrome"
    return ()
perform action handle = do
    hPutStrLn handle "NOOP\r\n"
