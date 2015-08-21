module Desktop (switchDesktop, activate) where

import Data.Time.Clock (NominalDiffTime)
import System.Exit (ExitCode)

import Proc (runAppleScript)


keys = ["~", "[", "{", "}", "]", "=", "&", "*", "+", "^"]
switchScript = "../scripts/switch_space.scpt"
activateScript = "../scripts/activate.scpt"


switchDesktop :: Int -> IO (NominalDiffTime, Maybe (ExitCode, String, String))
switchDesktop x = runAppleScript [switchScript, keys !! (x - 1)]

activate :: String -> IO (NominalDiffTime, Maybe (ExitCode, String, String))
activate app = runAppleScript [activateScript, app]
