'use strict';

let fs = require('fs');
let initZ3 = require('./z3-built.js');

let checkResultToStr = r => ({
  '-1': 'unsat',
  '0': 'unknown',
  '1': 'sat',
})[r];

(async () => {
  let Module = await initZ3();
  let desc = fs.readFileSync('./solver.txt', 'utf8');

  function stringToPointer(str) {
    // leaks, but doesn't matter for this demo
    return Module.allocate(Module.intArrayFromString(str), Module.ALLOC_NORMAL);
  }

  // create a solver from the description in solver.txt
  // we're not going to bother cleaning any of this up because it's about to terminate anyway
  let conf = Module._Z3_mk_config();
  let ctx = Module._Z3_mk_context(conf);

  let solver = Module._Z3_mk_solver(ctx);
  Module._Z3_solver_inc_ref(ctx, solver);
  Module._Z3_solver_from_string(ctx, solver, stringToPointer(desc));

  let checkResult = Module._Z3_solver_check(ctx, solver);
  let reason = Module._Z3_solver_get_reason_unknown(ctx, solver);

  console.log('result with full constraints:', checkResultToStr(checkResult));
  console.log('reason:', JSON.stringify(Module.intArrayToString(reason)));

  // now try again but with a constraint removed
  // we could reuse the solver, but we might as well make a new one to avoid any potential state
  desc = desc.replace('(assert (<= c_8_8 9))', '');
  solver = Module._Z3_mk_solver(ctx);
  Module._Z3_solver_inc_ref(ctx, solver);
  Module._Z3_solver_from_string(ctx, solver, stringToPointer(desc));

  checkResult = Module._Z3_solver_check(ctx, solver);
  console.log('result with one missing constraint:', checkResultToStr(checkResult));

})().catch(e => { console.error(e); process.exit(1); });
