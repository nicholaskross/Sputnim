import SATFormula
import tables
import strutils



proc readLineToClause(line: string, formula: SATFormula): void =
  echo "made it in!"
  let splitted = line.split({' '})
  for i, v in splitted[0 .. len(splitted)-2]:
    echo string(v)

proc readFileToSAT(filename: string): SATFormula =
  var the_formula: SATFormula
  #the_formula.varTable = initTable[string, int]()
  #the_formula.varAssignment = initTable[string, bool]()
  #var infile: File = open(filename)
  var first = true
  for line in lines filename:
    if line.split({' '})[0] == "c":
      continue
    if first:
      first = false
      let splitted_firstline = line.split({' '})
      #echo splitted_firstline[2]
      the_formula.maxVars = parseInt(splitted_firstline[2])
      the_formula.numClausesInitial = parseInt(splitted_firstline[3])
    else:
      readLineToClause(line, the_formula)

  #infile.close()


var main_formula = readFileToSAT("examples/example1.cnf")