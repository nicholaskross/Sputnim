import SATFormula
import tables
import strutils
from solvers/DPLL import DPLL_func



proc readLineToClause(line: string, formula: var SATFormula): void =
  let splitted = line.split({' '})
  var this_clause:seq[int]
  for i, v in splitted[0 .. ^2]:
    let negated = v.startsWith("-")
    let thisvar =
      if negated:
        v[1 .. ^1]
      else:
        v
    if not formula.varTable.hasKey(thisvar):
      formula.varTable[thisvar] = len(formula.varTable)+1
      formula.varAssignment[thisvar] = 0
      formula.varLetters.add(thisvar)
    let this_literal = 
      if negated:
        formula.varTable[thisvar] * -1
      else:
        formula.varTable[thisvar]
    this_clause.add(this_literal)
  formula.clauses.add(this_clause)

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
      the_formula.varTable = initTable[string, int]()
      the_formula.varAssignment = initTable[string, int]()
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
      if v != 0:
        outstring = 
          if v == -1:
            outstring & "-" & k & " "
          else:
            outstring & k & " "
  write_file(outfilename, outstring)

var main_formula = readFileToSAT("examples/example1.cnf")

var solvedornot:bool

(solvedornot, main_formula) = DPLL_func(main_formula)

outputSolution(main_formula, solvedornot)