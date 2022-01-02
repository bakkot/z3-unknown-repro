#!/bin/bash

set -euxo pipefail

if [ ! -d "z3-c" ]; then
  echo 'Please `git clone git@github.com:Z3Prover/z3.git z3-c`'
  exit 1
fi

export ROOT=$PWD

cp -r -p z3/src z3-c
cd z3-c
# git clean -fx
# python scripts/mk_make.py --staticlib --debug --single-threaded
cd build
make -j8

cd $ROOT

g++ run-z3.cc z3-c/build/libz3.a -o run-z3
