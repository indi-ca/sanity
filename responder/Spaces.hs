module Spaces where

import Proc (runGeneric)
import System.Exit (ExitCode)

data Space = Space
    deriving (Show, Read)

data Monitor = Monitor {
    spaces :: [Space]
} deriving (Show, Read)


data AllSpaces = AllSpaces {
    monitors :: [Monitor]
} deriving (Show, Read)


monitorA = Monitor { spaces = [Space, Space, Space, Space, Space]}
monitorB = Monitor { spaces = [Space, Space]}

allSpaces = AllSpaces {monitors = [monitorA, monitorB]}


spacesScript = "/Users/indika/Library/Caches/appCode31/DerivedData/SpaceIdentifier-6b864c24/Build/Products/Debug/SpaceIdentifier"


deconstruct :: Maybe (ExitCode, String, String) -> String
deconstruct Nothing = ""
deconstruct (Just (_, output, error)) = output

main :: IO ()
main = do
    (_, resp) <- runGeneric spacesScript []
    let entity = read (deconstruct resp) :: AllSpaces
    putStrLn $ show entity
