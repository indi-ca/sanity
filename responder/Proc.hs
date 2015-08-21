{-# LANGUAGE BangPatterns #-}

module Proc (runAppleScript) where

import Data.Time.Clock (diffUTCTime, getCurrentTime, NominalDiffTime)

import System.Exit (ExitCode)
import System.Process (readProcessWithExitCode)
import System.Timeout (timeout)

oTimeout = 5
tmout = oTimeout * 1000000


-- | time the given IO action (clock time) and return a tuple
--   of the execution time and the result
timeIO :: IO a -> IO (NominalDiffTime, a)
timeIO ioa = do
    t1 <- getCurrentTime
    !a <- ioa
    t2 <- getCurrentTime
    return (diffUTCTime t2 t1, a)

runTask :: Int -> [String] -> IO ( (NominalDiffTime, Maybe (ExitCode, String, String)) )
runTask tmout args = do
    (time, res) <- timeIO . timeout tmout $ readProcessWithExitCode "osascript" args []
    return (time, res)

runAppleScript :: [String] -> IO ( (NominalDiffTime, Maybe (ExitCode, String, String)) )
runAppleScript args = runTask tmout args

main :: IO ()
main = do
    (t, exit_code) <- runTask tmout ["switch_space.scpt", "]"]
    putStrLn $ show t
    -- putStrLn exit_code
    putStr "Done"



