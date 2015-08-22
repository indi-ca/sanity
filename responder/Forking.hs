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

    infoM "Sanity.Responder" $ "Logging has started"

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


runConn :: (Socket, SockAddr) -> Chan Msg -> Int -> IO ()
runConn (sock, _) chan nr = do
    let broadcast msg = writeChan chan (nr, msg)
    hdl <- socketToHandle sock ReadWriteMode
    hSetBuffering hdl NoBuffering
    action <- liftM init (hGetLine hdl)
    perform action hdl
    debugM "Sanity.Responder" $ "Got request: " ++  action
    hClose hdl
