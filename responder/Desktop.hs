module Desktop (switchDesktop, activate, sublime) where

import Data.Time.Clock (NominalDiffTime)
import System.Exit (ExitCode)
import System.FilePath (joinDrive)

import Proc (runAppleScript)


keys = ["~", "[", "{", "}", "]", "=", "&", "*", "+", "^"]
switchScript = "switch_space.scpt"
activateScript = "activate.scpt"
sublimeScript = "sublime_raise.scpt"

scriptsPath = "/Users/indika/dev/sanity/scripts/"

resolveScript :: String -> String
resolveScript script = joinDrive scriptsPath script


switchDesktop :: Int -> IO (NominalDiffTime, Maybe (ExitCode, String, String))
switchDesktop x = runAppleScript [resolveScript switchScript, keys !! (x - 1)]

activate :: String -> IO (NominalDiffTime, Maybe (ExitCode, String, String))
activate app = runAppleScript [resolveScript activateScript, app]

sublime :: IO (NominalDiffTime, Maybe (ExitCode, String, String))
sublime = runAppleScript [resolveScript sublimeScript, "write"]
