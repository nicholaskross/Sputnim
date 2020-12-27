import tables

type
  SATFormula* = object
    varLetters*: seq[string]
    varnumToOriginal*: Table[int, string]  # variable# of the original_string
    originalToVarnum*: Table[string, int]  # vice-versa
    varAssignment*: Table[string, int]  # str(variable#) of the -1,0,1
    clauses*: Table[int, Table[int, int]]  # table of tables of ints
    maxVars*: int
    numClausesInitial*: int
    originalFilename*: string