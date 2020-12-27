# Sputnim

[![Nim language-plastic](https://github.com/Ethosa/open-source-badges/blob/master/badges/Languages/Nim/Nim-lang-plastic.svg)](https://github.com/Ethosa/open-source-badges/blob/master/badges/Languages/Nim/Nim-lang-plastic.svg)

SAT solver in Nim, based on the basic (not-much-optimized) [DPLL algorithm](https://en.wikipedia.org/wiki/DPLL_algorithm). Part of the architecture (especially data representation) is based on [simple-sat](https://github.com/sahands/simple-sat).

## Usage
```bash
$ git clone https://github.com/nicholaskross/Sputnim

$ cd Sputnim

# Compiling+Running
$ nim compile --verbosity:0 --hints:off --run sputnim.nim examples/example1.cnf

# Running
$ sputnim.exe examples/example2.cnf examples/custom_output_name.out
```
