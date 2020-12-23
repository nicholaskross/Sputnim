import SATFormula
import tables

proc test_sputnim(): void = 
  echo "Testing this!"

var the_formula: SATFormula

the_formula.varTable = initTable[string, int]()