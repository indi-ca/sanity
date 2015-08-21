module WindowManager (perform) where

import System.IO (hPutStrLn, Handle)
import Desktop (activate, switchDesktop, sublime)


perform :: String -> Handle -> IO ()
perform "ping" handle = hPutStrLn handle "pong"
perform "F1" handle = do
    activate "iTerm"
    return ()
perform "F2" handle = do
    sublime
    return ()
perform "F3" handle = do
    switchDesktop 2
    activate "Slack"
    return ()
perform "CMD-F3" handle = do
    switchDesktop 2
    activate "LimeChat"
    return ()
perform "F4" handle = do
    activate "Google Chrome"
    return ()
perform action handle = do
    switchDesktop 5
    putStrLn action
    return ()
