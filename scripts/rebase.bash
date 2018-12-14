#!/usr/bin/env bash

function main() {
  local multiple_master_repositories=( llvm clang lldb )
  local single_master_repositories=( clang-tools-extra lld cmark swift swift-corelibs-foundation swift-corelibs-libdispatch swift-corelibs-xctest swift-llbuild swift-package-manager swift-syntax )
  local runtime_repositories=( compiler-rt libunwind libcxxabi libcxx openmp )
  local toolchain_source=$(realpath -q $(dirname $(readlink -f ${0}))/../..)

  for repo in ${multiple_master_repositories[@]} ${single_master_repositories[@]} ; do
    local GIT_DIR=${toolchain_source}/${repo}
    if ! git -C ${GIT_DIR} diff --no-ext-diff --quiet ||
       ! git -C ${GIT_DIR} diff --no-ext-diff --quiet --cached ; then
      echo "${repo} is dirty, aborting rebase"
      exit -1
    fi
  done

  for repo in ${multiple_master_repositories[@]} ; do
    local GIT_DIR=${toolchain_source}/${repo}

    git -C ${GIT_DIR} fetch -q upstream
    git -C ${GIT_DIR} fetch -q swift

    local master=$(git -C ${GIT_DIR} rev-parse HEAD)
    local swift_merge_point=$(git -C ${GIT_DIR} merge-base upstream/master swift/upstream-with-swift)
    local local_merge_point=$(git -C ${GIT_DIR} log --reverse --no-merges --grep 'git-svn-id' --invert-grep --oneline --pretty=%H $(git -C ${GIT_DIR} merge-base HEAD upstream/master)..HEAD ^swift/upstream-with-swift | head -n 1)
    [[ -n ${local_merge_point} ]] && echo "local changes: ${local_merge_point}..$(git -C ${GIT_DIR} rev-parse HEAD)"

    git -C ${GIT_DIR} checkout swift/upstream-with-swift || exit 253
    git -C ${GIT_DIR} rebase --no-stat --onto HEAD ${swift_merge_point}^ upstream/master || {
      sh -c "cd ${GIT_DIR}; exec /bin/sh"
    }
    if [[ -n ${local_merge_point} ]] ; then
      git -C ${GIT_DIR} rebase --onto HEAD ${local_merge_point}^ ${master} || {
        sh -c "cd ${GIT_DIR}; exec /bin/sh"
      }
    fi
  done

  for repo in ${single_master_repositories[@]} ; do
    local GIT_DIR=${toolchain_source}/${repo}
    git -C ${GIT_DIR} fetch -q upstream
    git -C ${GIT_DIR} rebase --no-stat upstream/master || exit 253
  done
}

main "${@}"

