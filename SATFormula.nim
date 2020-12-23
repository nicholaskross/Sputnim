import tables

type
  SATFormula* = object
    varLetters*: seq[string]
    varTable*: Table[string, int]