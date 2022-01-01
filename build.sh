#!/bin/bash

set -euxo pipefail

if [ ! -d "z3" ]; then
  echo 'Please `git clone git@github.com:Z3Prover/z3.git`'
  exit 1
fi

export ROOT=$PWD

# mkdir -p z3/build
# cd z3/build
# emcmake cmake \
#   -DCMAKE_BUILD_TYPE=MinSizeRel \
#   -DZ3_BUILD_LIBZ3_SHARED=OFF \
#   -DZ3_ENABLE_EXAMPLE_TARGETS=OFF \
#   -DZ3_BUILD_TEST_EXECUTABLES=OFF \
#   -DZ3_BUILD_EXECUTABLE=OFF \
#   -DZ3_SINGLE_THREADED=ON \
#   -DCMAKE_CXX_FLAGS="-s DISABLE_EXCEPTION_CATCHING=0" \
#   ..;
# make -j$(nproc)


cd $ROOT

export EM_CACHE=$HOME/.emscripten/
export FNS='["_Z3_mk_config","_Z3_mk_context","_Z3_mk_solver","_Z3_solver_inc_ref","_Z3_solver_from_string","_Z3_solver_check","_Z3_solver_get_reason_unknown"]'
emcc just-z3.c z3/build/libz3.a -g2 -fexceptions -s MODULARIZE=1 -s 'EXPORT_NAME="initZ3"' -s EXPORTED_RUNTIME_METHODS='["allocate","intArrayToString","intArrayFromString","ALLOC_NORMAL"]' -s SAFE_HEAP=0 -s DEMANGLE_SUPPORT=1 -s EXPORTED_FUNCTIONS=${FNS} -s DISABLE_EXCEPTION_CATCHING=0 -s TOTAL_MEMORY=1GB -I z3/src/api/ -o z3-built.js
