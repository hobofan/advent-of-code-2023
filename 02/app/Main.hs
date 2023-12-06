module Main where

import qualified MyLib (someFunc)
import Data.Char (isDigit)
import Data.List.Split (splitOn)
import Data.List (isInfixOf)
import Text.Parsec
import Text.Parsec.String (Parser)

data BagSet = BagSet { numRed :: Int, numBlue :: Int, numGreen :: Int } deriving (Show, Eq)

data Game = Game { gameId :: Int, bagSets :: [BagSet] } deriving (Show, Eq)

parseBagSet :: Parser BagSet
parseBagSet = do
 colors <- many (do
   _ <- space
   num <- many1 digit
   _ <- space
   color <- many1 letter
   _ <- optional (char ',')
   return (read num, color))
 return $ BagSet (sum [n | (n, "red") <- colors])
                (sum [n | (n, "blue") <- colors])
                (sum [n | (n, "green") <- colors])

parseGame :: Parser Game
parseGame = do
 _ <- string "Game "
 gameId <- many1 digit
 _ <- char ':'
 bagSets <- sepBy parseBagSet (char ';')
 return $ Game (read gameId) bagSets


readGames :: FilePath -> IO [Game]
readGames file = do
 content <- readFile file
 let games = map (either (error . show) Prelude.id . parse parseGame "") $ lines content
 return games

main :: IO ()
main = do
  let maxRed = 12
  let maxGreen = 13
  let maxBlue = 14

  games <- readGames "input"
  let filteredGames = filter (all ((<= maxRed) . numRed) . bagSets)
                 . filter (all ((<= maxGreen) . numGreen) . bagSets)
                 . filter (all ((<= maxBlue) . numBlue) . bagSets)
                 $ games
  let idSum = sum $ map gameId filteredGames

  print idSum
