import Network.Socket
import System.IO
-- import Control.Exception
import Control.Concurrent
-- import Control.Concurrent.Chan
import Control.Monad
import Control.Monad.Fix (fix)

import System.Log.Logger
import System.Log.Handler.Syslog
-- import System.Log.Handler.Simple
-- import System.Log.Handler (setFormatter)
-- import System.Log.Formatter

import Desktop (activate, switchDesktop)

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


perform :: String -> IO ()
perform action = do
    switchDesktop 2
    activate "Slack"
    return ()


runConn :: (Socket, SockAddr) -> Chan Msg -> Int -> IO ()
runConn (sock, _) chan nr = do
    let broadcast msg = writeChan chan (nr, msg)
    hdl <- socketToHandle sock ReadWriteMode
    hSetBuffering hdl NoBuffering
    action <- liftM init (hGetLine hdl)
    perform action
    debugM "Sanity.Responder" $ "Got request: " ++  action
    hPutStrLn hdl action
    hPutStrLn hdl "OK"
    hClose hdl
