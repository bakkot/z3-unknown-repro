# Z3-wasm wasm issues repro

I'm trying to get Z3 running on wasm. Initially I tried building without pthreads, which appeared to work, but which actually would silently fail to run some tactics because they rely on a timer which is implemented with threads.

Now it's building with pthreads, and that tactic runs, but it then hangs. Specifically, it prints

```
(simplifier :num-exprs 303 :num-asts 551 :time 0.03 :before-memory 9.45 :after-memory 9.45)
(simplifier :num-exprs 1896 :num-asts 2252 :time 0.13 :before-memory 9.45 :after-memory 9.55)
(propagate-values :num-exprs 1646 :num-asts 1971 :time 0.45 :before-memory 9.53 :after-memory 9.53)
(ctx-simplify :num-steps 6500)
(ctx-simplify :num-exprs 1646 :num-asts 1971 :time 0.09 :before-memory 9.55 :after-memory 9.58)
(simplifier :num-exprs 1646 :num-asts 1971 :time 0.10 :before-memory 9.53 :after-memory 9.53)
(solve_eqs :num-exprs 1598 :num-asts 1971 :time 0.37 :before-memory 9.53 :after-memory 9.53)
(:num-elim-vars 24)
(elim-uncnstr :num-exprs 1598 :num-asts 1971 :time 0.02 :before-memory 9.53 :after-memory 9.53)
(simplifier :num-exprs 2016 :num-asts 2389 :time 0.20 :before-memory 9.53 :after-memory 9.55)
(ilp-model-finder-tactic start)
(ilp-model-finder-tactic done)
(pb-tactic start)
(pb-tactic done)
(bounded-tactic start)
(no-cut-smt-tactic start)
(smt.tactic start)
(smt.propagate-values)
(smt.nnf-cnf)
(smt.reduce-asserted)
(smt.maximizing-bv-sharing)
(smt.reduce-asserted)
(smt.flatten-clauses)
(smt.simplifier-done)
(smt.searching)
(smt.stats :restarts   :decisions  :clauses/bin           :simplify   :memory)
(smt.stats      :conflicts   :propagations    :lemmas        :deletions     )
(smt.stats    0    101    362   9516  3414/2961  1275/470     2  340   11.80)
(smt.stats    1    153    635  16545  3390/2961  1622/658     3  443   11.93)
(smt :num-exprs 0 :num-asts 2405 :time 28.13 :before-memory 9.55 :after-memory 9.57)
(no-cut-smt-tactic done)
```

and then hangs indefinitely (or at least the 10 minutes I was willing to wait) while pegging a single core. If built natively, on my machine it gets to the same point but then immediately prints `(bounded-tactic done)` and completes the call to `Z3_solver_check`.
