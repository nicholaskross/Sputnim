import ../SATFormula
import tables
#import sequtils

proc is_consistent_set_of_literals(formula: SATFormula): bool =
  var seen: seq[int]
  for clause in formula.clauses:
    if len(clause) != 1:
      return false
    if seen.contains(-1*clause[0]):
      return false
    if not seen.contains(clause[0]):
      seen.add(clause[0])
  return true


proc contains_empty_clause(formula: SATFormula): bool =
  for clause in formula.clauses:
    if len(clause) == 0:
      return true
  return false


proc unit_propagate(l:int, formula: var SATFormula): void =
  for clause in formula.clauses:
    for literal in clause:
      if literal == l:
        #formula.clauses.remove(clause)
        break

proc DPLL_func*(old_formula:var SATFormula): (bool, SATFormula) =
  var formula = deepCopy(old_formula)
  if is_consistent_set_of_literals(formula):
    return (true, formula)
  if contains_empty_clause(formula):
    return (false, formula)
  
  var unit_clauses: seq[(seq[int], int)]
  for clause in formula.clauses:
    var unassigned_literal_count = 0
    var possible_unit_lit: int
    for literal in clause:
      if formula.varAssignment[$abs(literal)] == 0:  # if unassigned.
        unassigned_literal_count += 1
        possible_unit_lit = literal
    if unassigned_literal_count == 1:
      unit_clauses.add((clause, possible_unit_lit))
  
  for unitclause_tuple in unit_clauses:
    unit_propagate(unitclause_tuple[1], formula)
  #pure_literal_assign(purelit, formula)

  # "solution" stub
  for key, value in formula.varAssignment:
    formula.varAssignment[key] = 1
  
  return (true, formula)