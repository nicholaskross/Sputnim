import ../SATFormula
import tables



proc DPLL_func*(old_formula:var SATFormula): (bool, SATFormula) =
  var formula = deepCopy(old_formula)
  # "solution" stub
  for key, value in formula.varAssignment:
    formula.varAssignment[key] = 1
  return (true, formula)