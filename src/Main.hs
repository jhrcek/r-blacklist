{-# LANGUAGE GADTs #-}
{-# LANGUAGE QuasiQuotes #-}

module Main where

import qualified Language.R.HExp as HE
import qualified Language.R.Instance as R

import H.Prelude (R, SomeSEXP (..))
import Language.R.Matcher (charList)
import Language.R.QQ (r)
import System.Environment (getArgs)


main :: IO ()
main = do
    args <- getArgs
    case args of
        [] -> error "Usage: r-blacklist path/to/script.R"
        (file : _) -> do
            namesOfUsedFunctions <- R.withEmbeddedR R.defaultConfig $ R.runRegion $ listFunctionsUsedIn file
            print namesOfUsedFunctions


listFunctionsUsedIn :: FilePath -> R s (Maybe [String])
listFunctionsUsedIn file = do
    SomeSEXP sexp <- [r| expr <- parse(file_hs); all.names(expr, functions=TRUE, unique=TRUE);|]
    pure $ case HE.hexp sexp of
        HE.String _ -> Just $ charList sexp
        _ -> Nothing