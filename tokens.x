{
-- Cabeçalho Haskell
module Main (main) where
}

%wrapper "basic"

-- Definições (macros) para partes de expressões regulares.
$digit = 0-9
$lower = [a-z]
$upper = [A-Z]
$alpha = [$lower $upper]

tokens :-

  -- 1. Ignorar espaços em branco e novas linhas
  $white+                               ;

  -- 2. Ignorar comentários de linha única
  "//".* ;

  -- 3. Palavras-chave (as mais específicas vêm primeiro)
  "type"                                { \_ -> TypeKW }
  "def"                                 { \_ -> DefKW }
  "end-type"                            { \_ -> EndTypeKW }
  "abbrev"                              { \_ -> AbbrevKW }
  "fn"                                  { \_ -> FnKW }
  "do"                                  { \_ -> DoKW }
  "return"                              { \_ -> ReturnKW }
  "let"                                 { \_ -> LetKW }
  "skip"                                { \_ -> SkipKW }
  "for"                                 { \_ -> ForKW }
  "in"                                  { \_ -> InKW }
  "end-for"                             { \_ -> EndForKW }
  "if"                                  { \_ -> IfKW }
  "then"                                { \_ -> ThenKW }
  "else"                                { \_ -> ElseKW }
  "end-if"                              { \_ -> EndIfKW }
  "print!"                              { \_ -> PrintBang }
  "scan?"                               { \_ -> ScanQ }
  "scan!"                               { \_ -> ScanBang }
  "orElse"                              { \_ -> OrElseKW }
  "toString"                            { \_ -> ToStringKW }
  "import"                              { \_ -> ImportKW }
  "match"                               { \_ -> MatchKW }
  "with"                                { \_ -> WithKW }
  "end-case"                            { \_ -> EndCaseKW }
  "otherwise"                           { \_ -> OtherwiseKW }
  "end-match"                           { \_ -> EndMatchKW }
  "end-main"                            { \_ -> EndMainKW }
  "end-weirdSum"                        { \_ -> EndWeirdSumKW }

  -- 4. Operadores e Símbolos (os de múltiplos caracteres vêm primeiro)
  "->"                                  { \_ -> Arrow }
  "++"                                  { \_ -> Concat }
  ".."                                  { \_ -> Range }
  "="                                   { \_ -> Eq }
  ":"                                   { \_ -> Colon }
  "."                                   { \_ -> Dot }
  ","                                   { \_ -> Comma }
  "+"                                   { \_ -> Plus }
  "/"                                   { \_ -> Slash }
  ">"                                   { \_ -> GreaterThan }
  "<"                                   { \_ -> LessThan }
  "("                                   { \_ -> LParen }
  ")"                                   { \_ -> RParen }
  "["                                   { \_ -> LBracket }
  "]"                                   { \_ -> RBracket }

  -- 5. Literais (números e strings)
  $digit+\.$digit+                      { \s -> FloatLit (read s) }
  $digit+                               { \s -> IntLit (read s) }
  \"[^\"\n]*\"                           { \s -> StringLit (init (tail s)) }

  -- 6. Identificadores (A ORDEM É IMPORTANTE!)
  @$alpha[$alpha $digit _]* { \s -> GlobalId s }
  $upper[$alpha $digit _]* { \s -> TypeId s }
  $lower[$alpha $digit _]*\?            { \s -> VarIdQ s }
  $lower[$alpha $digit _]* { \s -> VarId s }

{
-- Código Haskell que será inserido no final do arquivo gerado

data Token
  = TypeKW | DefKW | EndTypeKW | AbbrevKW
  | FnKW | DoKW | ReturnKW
  | LetKW | SkipKW
  | ForKW | InKW | EndForKW
  | IfKW | ThenKW | ElseKW | EndIfKW
  | PrintBang | ScanQ | ScanBang | OrElseKW | ToStringKW
  -- Novos Keywords
  | ImportKW | MatchKW | WithKW | EndCaseKW | OtherwiseKW | EndMatchKW | EndMainKW | EndWeirdSumKW
  -- Símbolos
  | Arrow | Concat | Range | Eq | Colon | Dot | Comma
  | Plus | Slash | GreaterThan | LessThan
  | LParen | RParen | LBracket | RBracket
  -- Literais
  | IntLit Integer
  | FloatLit Double
  | StringLit String
  -- Identificadores
  | GlobalId String
  | TypeId String -- Ex: User, Client, MkClient, Some
  | VarIdQ String -- Ex: x?
  | VarId String  -- Ex: main, weirdSum, x, y, z
  deriving (Eq, Show)

-- Função principal para testar o scanner
main :: IO ()
main = do
  s <- getContents
  print (alexScanTokens s)

}