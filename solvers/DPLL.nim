import ../SATFormula
import tables
from strutils import parseInt


proc is_consistent_set_of_literals(formula: SATFormula): bool =
  var seen: seq[int]
  for k, clause in formula.clauses:
    if len(clause) != 1:
      return false
    var onlylit:int
    for k, v in clause:
      onlylit=k
    if seen.contains(-1*onlylit):
      return false
    if not seen.contains(onlylit):
      seen.add(onlylit)
  return true



proc contains_empty_clause(formula: SATFormula): bool =
  for k, clause in formula.clauses:
    if len(clause) == 0:
      return true
  return false



proc unit_propagate(l:int, formula: var SATFormula): void =
  formula.varAssignment[$abs(l)] = 
    if l < 0:
      -1
    else:
      1
  var newclauses = initTable[int, Table[int, int]]()
  for k, clause in formula.clauses:
    var newclause = initTable[int, int]()
    var newclauseflag = true
    for literal, _ in clause:
      newclauseflag = true
      if literal == l:
        newclauseflag = false
        break
      if literal != -1*l:
        newclause[literal] = literal
    if newclauseflag:
      newclauses[len(newclauses)+1] = newclause
  formula.clauses = newclauses



proc pure_literal_assign(l:int, formula: var SATFormula): void =
  formula.varAssignment[$abs(l)] = 
    if l < 0:
      -1
    else:
      1
  var newclauses = initTable[int, Table[int, int]]()
  var newclauseflag = true
  for k, clause in formula.clauses:
    newclauseflag = true
    var newclause = initTable[int, int]()
    for literal, _ in clause:
      if literal == l:
        newclauseflag = false
        break
      newclause[literal] = literal
    if newclauseflag:
      newclauses[len(newclauses)+1] = newclause
  formula.clauses = newclauses



proc DPLL_solve*(old_formula:var SATFormula): (bool, SATFormula) =
  var formula = deepCopy(old_formula)
  if is_consistent_set_of_literals(formula):
    return (true, formula)
  if contains_empty_clause(formula):
    return (false, formula)
  
  var unit_clauses: seq[(Table[int, int], int)]
  for k, clause in formula.clauses:
    var unassigned_literal_count = 0
    var possible_unit_lit: int
    for literal, _ in clause:
      if formula.varAssignment[$abs(literal)] == 0:  # if unassigned.
        unassigned_literal_count += 1
        possible_unit_lit = literal
    if unassigned_literal_count == 1:
      unit_clauses.add((clause, possible_unit_lit))
  
  for unitclause_tuple in unit_clauses:
    unit_propagate(unitclause_tuple[1], formula)
  
  var pure_literals: Table[int, int]
  var impure_literals: Table[int, int]
  for k, clause in formula.clauses:
    for literal, _ in clause:
      if not impure_literals.hasKey(literal):
        if pure_literals.hasKey(-1*literal):
          pure_literals.del(-1*literal)
          impure_literals[literal] = literal
          impure_literals[-1*literal] = -1*literal
  
  for purelit, _ in pure_literals:
    pure_literal_assign(purelit, formula)

  var nextlit: int = 0
  for litstr, assigned in formula.varAssignment:
    if assigned == 0:
      nextlit = parseInt(litstr)
      break

  if nextlit == 0:
    return (true, formula)

  var newclause_left = initTable[int, int]()
  var left_result: bool
  newclause_left[nextlit] = nextlit
  var leftbranch_formula = deepCopy(formula)
  leftbranch_formula.varAssignment[$nextlit] = 1
  leftbranch_formula.clauses[len(leftbranch_formula.clauses)+1] = newclause_left
  (left_result, leftbranch_formula) = DPLL_solve(leftbranch_formula)

  if left_result:
    return (left_result, leftbranch_formula)
  else:
    var newclause_right = initTable[int, int]()
    var right_result: bool
    newclause_right[-1*nextlit] = -1*nextlit
    var rightbranch_formula = deepCopy(formula)
    rightbranch_formula.varAssignment[$nextlit] = -1
    rightbranch_formula.clauses[len(rightbranch_formula.clauses)+1] = newclause_right
    (right_result, rightbranch_formula) = DPLL_solve(rightbranch_formula)
    return (right_result, rightbranch_formula)