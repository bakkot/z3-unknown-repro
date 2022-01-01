# Z3-wasm empty unknown reason repro

This demonstrates a case where the wasm build of z3 produces 'unknown' for a satisfiable problem and fails to give a reason.

`build.sh` will create the wasm build, but I've checked the resulting artifacts in, so you shouldn't need to set up emscripten or running.

`solver.txt` contains the result of a call to `Z3_solver_to_string` for a standard sudoko problem. It's satisfiable: you can run `z3 solver.txt` yourself to see `sat`.

Running `node run-z3-node.js` will load the wasm, then use it to create a solver and attempt to check it in the same way. This results in `unknown`. Calling `Z3_solver_get_reason_unknown` returns the empty string.

If you remove a constraint and try again - which the script will proceed to do - it will be `sat` instead.

You can also build and run `run-z3.cc`, which has the same set of commands as the JS API and which prints sat (i.e. 1).
