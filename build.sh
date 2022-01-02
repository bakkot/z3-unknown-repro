#!/bin/bash

set -euxo pipefail

if [ ! -d "z3" ]; then
  echo 'Please `git clone git@github.com:Z3Prover/z3.git`'
  exit 1
fi

export ROOT=$PWD

cd z3
# mkdir -p build
# cd build
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

cd $ROOT/z3
# git clean -fx
export CXXFLAGS="-pthread -s USE_PTHREADS=1 -s DISABLE_EXCEPTION_CATCHING=0"
export LDFLAGS="-pthread -s USE_PTHREADS=1"
emconfigure python scripts/mk_make.py --staticlib --debug --single-threaded
cd build
emmake make -j$(nproc)

cd $ROOT

export EM_CACHE=$HOME/.emscripten/
export FNS='["_main","_Z3_enable_trace","_Z3_get_error_code","_Z3_global_param_set","_Z3_mk_config","_Z3_mk_context","_Z3_mk_solver","_Z3_solver_inc_ref","_Z3_solver_from_string","_Z3_solver_check","_Z3_solver_get_reason_unknown"]'
emcc run-z3.cc z3/build/libz3.a --embed-file solver.txt -g2 -pthread -fexceptions -s USE_PTHREADS=1 -s PTHREAD_POOL_SIZE=4 -s MODULARIZE=1 -s 'EXPORT_NAME="initZ3"' -s EXPORTED_RUNTIME_METHODS='["FS","allocate","intArrayToString","intArrayFromString","ALLOC_NORMAL"]' -s SAFE_HEAP=0 -s DEMANGLE_SUPPORT=1 -s EXPORTED_FUNCTIONS=${FNS} -s DISABLE_EXCEPTION_CATCHING=0 -s TOTAL_MEMORY=1GB -I z3/src/api/ -o z3-built.js
