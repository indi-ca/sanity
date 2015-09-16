import Control.Concurrent
import Control.Monad
import Control.Monad.Fix (fix)
import Network.Socket
import System.IO
import System.Log.Logger
import System.Log.Handler.Simple
import System.Log.Formatter (simpleLogFormatter)
import System.Log.Handler (setFormatter)

import WindowManager (perform)
import State (State)

type Msg = (Int, String)

port = 62505


main :: IO ()
main = do
    h <- fileHandler "/Users/indika/Library/Logs/sanity.log" DEBUG >>= \lh -> return $
        setFormatter lh (simpleLogFormatter "[$time : $loggername : $prio] $msg")
    updateGlobalLogger rootLoggerName (addHandler h)
    updateGlobalLogger "Sanity.Responder"
                       (setLevel DEBUG)

    infoM "Sanity.Responder" "Logging has started"

    -- create socket
    sock <- socket AF_INET Stream 0
    -- make socket immediately reusable - eases debugging.
    setSocketOption sock ReuseAddr 1
    bindSocket sock (SockAddrInet port iNADDR_ANY)
    -- allow a maximum of 2 outstanding connections
    listen sock 2
    mainLoop sock


mainLoop :: Socket -> IO ()
mainLoop sock = do
    -- accept one connection and handle it
    conn <- accept sock
    runConn conn
    mainLoop sock

runConn (sock, _) = do
    hdl <- socketToHandle sock ReadWriteMode
    hSetBuffering hdl NoBuffering
    action <- liftM init (hGetLine hdl)
    debugM "Sanity.Responder" $ "Got request: " ++  action

    perform action hdl
    -- I will stick to one response per action
    -- hPutStrLn hdl "OK\r\n"
    hClose hdl

