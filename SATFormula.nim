import tables

type
  SATFormula* = object
    varLetters*: seq[string]
    varTable*: Table[string, int]
    varAssignment*: Table[string, int]
    clauses*: seq[seq[int]]
    maxVars*: int
    numClausesInitial*: int