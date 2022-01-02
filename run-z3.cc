#include <fstream>
#include <sstream>
#include "z3/src/api/z3.h"

using namespace std;

int main(void) {
  ifstream f("solver.txt");
  stringstream buffer;
  buffer << f.rdbuf();
  string desc = buffer.str();

  Z3_global_param_set("verbose", "10");

  // create a solver from the description in solver.txt
  // we're not going to bother cleaning any of this up because it's about to terminate anyway
  Z3_config conf = Z3_mk_config();
  Z3_context ctx = Z3_mk_context(conf);
  Z3_solver solver = Z3_mk_solver(ctx);
  Z3_solver_inc_ref(ctx, solver);
  Z3_solver_from_string(ctx, solver, desc.c_str());

  Z3_lbool result = Z3_solver_check(ctx, solver);
  printf("result: %x\n", result);
}
