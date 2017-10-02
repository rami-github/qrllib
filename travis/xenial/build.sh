#!/usr/bin/env bash

BUILD_DIR="build"

set -e

cd /travis
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}
cmake -DCMAKE_C_COMPILER=gcc-${CC_VER} -DCMAKE_CXX_COMPILER=g++-${CC_VER} -DCMAKE_BUILD_TYPE=Release ${CMAKE_ARGS} /travis
make

if [ -n "${TEST:+1}" ]; then
  echo "Running Tests"
  export GTEST_COLOR=1
  ctest -VV

  if [[ ${CMAKE_ARGS} == *"BUILD_PYTHON=ON"* ]]; then
    python3 setup.py test
  fi

fi

if [ -n "${DEPLOY:+1}" ]; then
    cd /travis
    python3 setup.py sdist
fi
