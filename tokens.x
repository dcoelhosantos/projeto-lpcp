{
module Main (main) where
import Data.Char
import System.IO
}

%wrapper "posn"

$digit = 0-9
$lower = [a-z]
$upper = [A-Z]
$alpha = [$lower $upper]

tokens :-

  $white+                                   ;
  "//".*                                    ;

  -- Palavras-chave
  "struct"                                  { \(AlexPn _ l c) _ -> Token Struct l c }
  "variant"                                 { \(AlexPn _ l c) _ -> Token Variant l c }
  "fn"                                      { \(AlexPn _ l c) _ -> Token Function l c }
  "var"                                     { \(AlexPn _ l c) _ -> Token Var l c }
  "const"                                   { \(AlexPn _ l c) _ -> Token Const l c }

  "int"                                     { \(AlexPn _ l c) _ -> Token IntType l c }
  "float"                                   { \(AlexPn _ l c) _ -> Token FloatType l c }
  "text"                                    { \(AlexPn _ l c) _ -> Token TextType l c }
  "bool"                                    { \(AlexPn _ l c) _ -> Token BoolType l c }
  "void"                                    { \(AlexPn _ l c) _ -> Token VoidType l c }

  "break"                                   { \(AlexPn _ l c) _ -> Token Stop l c }
  "again"                                   { \(AlexPn _ l c) _ -> Token Skip l c }
  "print"                                   { \(AlexPn _ l c) _ -> Token Printf l c }
  "scan"                                    { \(AlexPn _ l c) _ -> Token Scanf l c }

  "if"                                      { \(AlexPn _ l c) _ -> Token If l c }
  "else"                                    { \(AlexPn _ l c) _ -> Token Else l c }
  "while"                                   { \(AlexPn _ l c) _ -> Token While l c }
  "for"                                     { \(AlexPn _ l c) _ -> Token For l c }
  "match"                                   { \(AlexPn _ l c) _ -> Token Match l c }
  "return"                                  { \(AlexPn _ l c) _ -> Token Return l c }

  -- Símbolos
  "{"                                       { \(AlexPn _ l c) _ -> Token BeginBrace l c }
  "}"                                       { \(AlexPn _ l c) _ -> Token EndBrace l c }
  "["                                       { \(AlexPn _ l c) _ -> Token BeginBracket l c }
  "]"                                       { \(AlexPn _ l c) _ -> Token EndBracket l c }
  "("                                       { \(AlexPn _ l c) _ -> Token BeginParentheses l c }
  ")"                                       { \(AlexPn _ l c) _ -> Token EndParentheses l c }
  ";"                                       { \(AlexPn _ l c) _ -> Token SemiColon l c }
  "."                                       { \(AlexPn _ l c) _ -> Token Dot l c }
  ","                                       { \(AlexPn _ l c) _ -> Token Comma l c }
  "::"                                      { \(AlexPn _ l c) _ -> Token DoubleColon l c }
  ":"                                       { \(AlexPn _ l c) _ -> Token Colon l c }
  "?"                                       { \(AlexPn _ l c) _ -> Token QuestionMark l c }
  "=="                                      { \(AlexPn _ l c) _ -> Token Equals l c }
  ">="                                      { \(AlexPn _ l c) _ -> Token GreaterEquals l c }
  "<="                                      { \(AlexPn _ l c) _ -> Token LesserEquals l c }
  "!="                                      { \(AlexPn _ l c) _ -> Token NotEquals l c }
  ">"                                       { \(AlexPn _ l c) _ -> Token Greater l c }
  "<"                                       { \(AlexPn _ l c) _ -> Token Lesser l c }
  "="                                       { \(AlexPn _ l c) _ -> Token Assign l c }
  "!"                                       { \(AlexPn _ l c) _ -> Token Not l c }
  "||"                                      { \(AlexPn _ l c) _ -> Token Or l c }
  "&&"                                      { \(AlexPn _ l c) _ -> Token And l c }
  "+"                                       { \(AlexPn _ l c) _ -> Token Add l c }
  "-"                                       { \(AlexPn _ l c) _ -> Token Sub l c }
  "*"                                       { \(AlexPn _ l c) _ -> Token Mul l c }
  "/"                                       { \(AlexPn _ l c) _ -> Token Div l c }
  "%"                                       { \(AlexPn _ l c) _ -> Token Rem l c }
  "&"                                       { \(AlexPn _ l c) _ -> Token Ampersand l c }

  -- Literais
  $digit+\.$digit+                          { \(AlexPn _ l c) s -> Token (FloatLit (read s)) l c }
  $digit+                                   { \(AlexPn _ l c) s -> Token (IntLit (read s)) l c }
  "true"                                    { \(AlexPn _ l c) _ -> Token (BoolLit True) l c }
  "false"                                   { \(AlexPn _ l c) _ -> Token (BoolLit False) l c }
  \" ([^\"\\] | \\ [nrt\"\\])* \"           { \(AlexPn _ l c) s -> Token (TextLit (unescape (init (tail s)))) l c }

  -- Identificadores
  $alpha [$alpha $digit _]*                 { \(AlexPn _ l c) s ->
      if isUpper (head s)
      then Token (TypeId s) l c
      else Token (VarId s) l c
  }


{
-- ========================================
-- Definição dos tipos de tokens
-- ========================================
data Token = Token
  { tokenType :: TokenType
  , tokenLine :: Int
  , tokenCol  :: Int
  } deriving (Eq, Show, Ord)

data TokenType =
    -- Palavras-chave
    Struct | Variant | Function | Var | Const
  | Stop | Skip | Printf | Scanf
  | If | Else | Match | While | For | Return

    -- Tipos primitivos
  | IntType | FloatType | TextType | BoolType | VoidType

    -- Símbolos
  | BeginBrace | EndBrace
  | BeginBracket | EndBracket
  | BeginParentheses | EndParentheses
  | SemiColon | Dot | Comma | DoubleColon | Colon | QuestionMark
  | Equals | NotEquals | GreaterEquals | LesserEquals
  | Assign | Not | Greater | Lesser
  | Or | And | Add | Sub | Mul | Div | Rem | Ampersand

    -- Literais
  | IntLit Integer
  | FloatLit Double
  | TextLit String
  | BoolLit Bool

    -- Identificadores
  | TypeId String
  | VarId String

  deriving (Eq, Show, Ord)

-- ========================================
-- Função para desescapar strings
-- ========================================
unescape :: String -> String
unescape ('\\':'n':xs) = '\n' : unescape xs
unescape ('\\':'r':xs) = '\r' : unescape xs
unescape ('\\':'t':xs) = '\t' : unescape xs
unescape ('\\':'\\':xs) = '\\' : unescape xs
unescape ('\\':'"':xs) = '"' : unescape xs
unescape (x:xs) = x : unescape xs
unescape [] = []

-- Função principal para testar o scanner
main :: IO ()
main = do
  s <- getContents
  print (alexScanTokens s)

}