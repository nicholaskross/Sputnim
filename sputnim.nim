import SATFormula
import tables
#import intsets
#import sets
import strutils
from solvers/DPLL import DPLL_solve



proc readLineToClause(line: string, formula: var SATFormula): void =
  let splitted = line.split({' '})
  var this_clause = initTable[int, int]()
  for i, v in splitted[0 .. ^2]:
    let negated = v.startsWith("-")
    let original_var =
      if negated:
        v[1 .. ^1]
      else:
        v
    var encoded:int
    if not formula.varLetters.contains(original_var):
      encoded = len(formula.varnumToOriginal)+1
      formula.varnumToOriginal[encoded] = original_var
      formula.originalToVarnum[original_var] = encoded
      formula.varAssignment[$encoded] = 0
      formula.varLetters.add(original_var)
    else:
      encoded = formula.originalToVarnum[original_var]
    var this_literal = 
        if negated:
          encoded * -1
        else:
          encoded
    this_clause[this_literal] = this_literal
  formula.clauses[len(formula.clauses)+1] = this_clause

proc readFileToSAT(filename: string): SATFormula =
  var the_formula = SATFormula()
  the_formula.originalFilename = filename
  var first = true
  for line in lines filename:
    if line.split({' '})[0] == "c":
      continue
    if first:
      first = false
      let splitted_firstline = line.split({' '})
      the_formula.maxVars = parseInt(splitted_firstline[2])
      the_formula.numClausesInitial = parseInt(splitted_firstline[3])
      the_formula.varnumToOriginal = initTable[int, string]()
      the_formula.originalToVarnum = initTable[string, int]()
      the_formula.varAssignment = initTable[string, int]()
      the_formula.clauses = initTable[int, Table[int, int]]()
    else:
      readLineToClause(line, the_formula)
  return the_formula


proc outputSolution(formula: SATFormula, solvedmaybe: bool): void =
  var outstring:string = ""
  let outfilename:string = formula.originalFilename.split({'.'})[0] & ".out"
  if not solvedmaybe:
    outstring = outstring & "UNSAT"
  else:
    outstring = outstring & "SATISFIABLE\n"
    for k, v in formula.varAssignment:
      let original_variable = formula.varnumToOriginal[parseInt(k)]
      if v != 0:
        outstring = 
          if v == -1:
            outstring & "-" & original_variable & " "
          else:
            outstring & original_variable & " "
  write_file(outfilename, outstring)

var main_formula = readFileToSAT("examples/example1.cnf")

var solvedornot:bool

(solvedornot, main_formula) = DPLL_solve(main_formula)

outputSolution(main_formula, solvedornot)