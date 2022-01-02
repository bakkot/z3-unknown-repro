'use strict';

let fs = require('fs');
let initZ3 = require('./z3-built.js');

let REMOVE_C889_CONSTRAINT = false;

let checkResultToStr = r => ({
  '-1': 'unsat',
  '0': 'unknown',
  '1': 'sat',
})[r];

(async () => {
  let Module = await initZ3();
  let desc = fs.readFileSync('./solver.txt', 'utf8');

  if (REMOVE_C889_CONSTRAINT) {
    desc = desc.replace('(assert (<= c_8_8 9))', '');
  }

  function stringToPointer(str) {
    // leaks, but doesn't matter for this demo
    return Module.allocate(Module.intArrayFromString(str), Module.ALLOC_NORMAL);
  }

  Module._Z3_global_param_set(stringToPointer("verbose"), stringToPointer('10'));

  // create a solver from the description in solver.txt
  // we're not going to bother cleaning any of this up because it's about to terminate anyway
  let conf = Module._Z3_mk_config();
  let ctx = Module._Z3_mk_context(conf);

  let solver = Module._Z3_mk_solver(ctx);
  Module._Z3_solver_inc_ref(ctx, solver);
  Module._Z3_solver_from_string(ctx, solver, stringToPointer(desc));

  let checkResult = Module._Z3_solver_check(ctx, solver);
  let reason = Module._Z3_solver_get_reason_unknown(ctx, solver);

  console.log('result:', checkResultToStr(checkResult));
  console.log('reason:', JSON.stringify(Module.intArrayToString(reason)));

})().catch(e => { console.error(e); process.exit(1); });
