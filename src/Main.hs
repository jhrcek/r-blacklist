{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE ViewPatterns #-}

module Main where

import qualified Data.Vector.SEXP as VS
import qualified Language.R.HExp as HE
import qualified Language.R.Instance as R

import Control.Memory.Region (V)
import Foreign.R (SEXP, SEXPTYPE (Char))
import H.Prelude (R, SomeSEXP (..))
import Language.R.QQ (r)


main :: IO ()
main = do
    putStrLn "Give me .R file you want to check:"
    file <- getLine
    functionsUsed <- R.withEmbeddedR R.defaultConfig $ R.runRegion $ listFunctionsUsedIn file
    print functionsUsed


listFunctionsUsedIn :: FilePath -> R s (Maybe [String])
listFunctionsUsedIn file = do
    SomeSEXP sexp <- [r| "hello" |]
    pure $ case HE.hexp sexp of
        (HE.String vecVec) -> Just $ VS.foldr (\x xs -> unwrapString x : xs) [] vecVec
        _ -> Nothing


unwrapString :: SEXP V 'Char -> String
unwrapString sexp = case HE.hexp sexp of
    (HE.Char vecChar) -> VS.toString vecChar