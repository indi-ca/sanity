module Spaces where

import Proc (runGeneric)
import System.Exit (ExitCode)

data Space = Space {
    id64 :: String,
    uuid :: String
} deriving (Show, Read)


data Monitor = Monitor {
    nameMonitor :: String,
    spaces :: [Space]
} deriving (Show, Read)


data MonitorData = MonitorData {
    monitors :: [Monitor]
} deriving (Show, Read)


data SpaceWindows = SpaceWindows {
    name :: String,
    windows :: [Integer]
} deriving (Show, Read)


data SpaceData = SpaceData [SpaceWindows]
    deriving (Show, Read)


data AllData = AllData {
    monitorData :: MonitorData,
    spaceData :: SpaceData
} deriving (Show, Read)


spacesScript = "/Users/indika/dev/sanity/scripts/spaces/SpaceIdentifier/build/Release/SpaceIdentifier"


deconstruct :: Maybe (ExitCode, String, String) -> String
deconstruct Nothing = ""
deconstruct (Just (_, output, error)) = output

main :: IO ()
main = do
    (_, resp) <- runGeneric spacesScript []
    let entity = read (deconstruct resp) :: AllData
    putStrLn $ show entity
