import Control.Concurrent
import Control.Monad
import Control.Monad.Fix (fix)
import Network.Socket
import System.IO
import System.Log.Logger
import System.Log.Handler.Syslog

import Desktop (activate, switchDesktop, sublime)

type Msg = (Int, String)

port = 62505

main :: IO ()
main = do
    s <- openlog "SyslogStuff" [PID] USER DEBUG
    updateGlobalLogger rootLoggerName (addHandler s)

    chan <- newChan
    sock <- socket AF_INET Stream 0
    setSocketOption sock ReuseAddr 1
    bindSocket sock (SockAddrInet port iNADDR_ANY)
    listen sock 2
    forkIO $ fix $ \loop -> do
        (_, msg) <- readChan chan
        loop
    mainLoop sock chan 0


mainLoop :: Socket -> Chan Msg -> Int -> IO ()
mainLoop sock chan nr = do
    conn <- accept sock
    runConn conn chan 0
    mainLoop sock chan $! nr+1


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
perform "F4" handle = do
    switchDesktop 2
    activate "LimeChat"
    return ()
perform action handle = do
    switchDesktop 5
    putStrLn action
    return ()


runConn :: (Socket, SockAddr) -> Chan Msg -> Int -> IO ()
runConn (sock, _) chan nr = do
    let broadcast msg = writeChan chan (nr, msg)
    hdl <- socketToHandle sock ReadWriteMode
    hSetBuffering hdl NoBuffering
    action <- liftM init (hGetLine hdl)
    perform action hdl
    debugM "Sanity.Responder" $ "Got request: " ++  action
    hClose hdl
