import SATFormula
import tables

proc test_sputnim(): void = 
  echo "Hello World!"

var the_formula: SATFormula

the_formula.varTable = initTable[string, int]()