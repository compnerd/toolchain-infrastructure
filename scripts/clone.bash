#!/usr/bin/env bash

function main() {
  local multiple_master_repositories=(
    llvm
    clang
    lldb
  )
  declare -A swift_only_repositories=(
    ["cmark"]="swift-cmark"
    ["swift"]="swift"
    ["swift-corelibs-foundation"]="swift-corelibs-foundation"
    ["swift-corelibs-libdispatch"]="swift-corelibs-libdispatch"
    ["swift-corelibs-xctest"]="swift-corelibs-xctest"
    ["swift-llbuild"]="swift-llbuild"
    ["swift-package-manager"]="swift-package-manager"
    ["swift-syntax"]="swift-syntax"
  )

  local llvm_only_repositories=(
    clang-tools-extra
    lld
  )

  local unused_runtime_repositories=(
    compiler-rt
    libunwind
    libcxxabi
    libcxx
    openmp
  )

  if [[ $(uname -a) =~ Darwin ]]; then
    readlink=greadlink
  else
    readlink=readlink
  fi

  local toolchain_source=$(realpath -q $(dirname $(${readlink} -f ${0}))/../..)
  declare -A pids

  function do_multiple() {
    git clone https://git.llvm.org/git/${1}.git ${2}
    git -C ${2} remote rename origin upstream
    git -C ${2} remote add swift https://github.com/apple/swift-${1}
  }

  for repo in ${multiple_master_repositories[@]}; do
    local GIT_DIR=${toolchain_source}/${repo}
    if test -d ${GIT_DIR}; then
      echo "${repo} already exists"
    else
      do_multiple ${repo} ${GIT_DIR} &
      pids[${repo}]=$!
    fi
  done

  function do_swift() {
    git clone https://github.com/apple/${3}.git ${2}
    git -C ${2} remote rename origin upstream
  }

  for repo in ${!swift_only_repositories[@]}; do
    local GIT_DIR=${toolchain_source}/${repo}
    if test -d ${GIT_DIR}; then
      echo "${repo} already exists"
    else
      do_swift ${repo} ${GIT_DIR} ${swift_only_repositories[${repo}]} &
      pids[${repo}]=$!
    fi
  done

  function do_llvm() {
    git clone https://git.llvm.org/git/${1}.git ${2}
    git -C ${2} remote rename origin upstream
  }

  for repo in ${llvm_only_repositories[@]}; do
    local GIT_DIR=${toolchain_source}/${repo}
    if test -d ${GIT_DIR}; then
      echo "${repo} already exists"
    else
      do_llvm ${repo} ${GIT_DIR} &
      pids[${repo}]=$!
    fi
  done

  for repo in "${!pids[@]}"; do
    wait ${pids[${repo}]}
  done
}

main "${@}"
