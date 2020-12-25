import tables

type
  SATFormula* = object
    varLetters*: seq[string]
    varTable*: Table[string, int]
    varAssignment*: Table[string, bool]
    maxVars*: int
    numClausesInitial*: int