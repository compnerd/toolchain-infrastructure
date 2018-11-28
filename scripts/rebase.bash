#!/usr/bin/env bash

function main() {
  local multiple_master_repositories=( llvm clang lldb )
  for repo in ${multiple_master_repositories[@]} ; do
    local GIT_DIR=$(realpath -q $(dirname $(readlink -f ${0}))/../..)/${repo}

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

  local single_master_repositories=( clang-tools-extra lld cmark swift swift-corelibs-foundation swift-corelibs-libdispatch swift-corelibs-xctest swift-llbuild swift-package-manager swift-syntax ) # compiler-rt libunwind libcxxabi libcxx openmp 
  for repo in ${single_master_repositories[@]} ; do
    local GIT_DIR=$(realpath -q $(dirname $(readlink -f ${0}))/../..)/${repo}
    git -C ${GIT_DIR} fetch -q upstream
    git -C ${GIT_DIR} rebase --no-stat upstream/master || exit 253
  done
}

main "${@}"

