module Main where

import qualified MyLib (someFunc)
import Data.Char (isDigit)
import Data.List.Split (splitOn)
import Data.List (isInfixOf, transpose)
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

power :: Game -> Int
power game = product $ map maximum $ transpose $ map (\bagSet -> [numRed bagSet, numGreen bagSet, numBlue bagSet]) (bagSets game)

main :: IO ()
main = do
  games <- readGames "input"
  let idSum = sum $ map power games

  print idSum
