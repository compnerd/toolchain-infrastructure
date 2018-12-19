
set(LLVM_TOOLCHAIN_TOOLS
      addr2line
      ar
      c++filt
      dsymutil
      dwp
      llvm-ar
      llvm-cxxfilt
      llvm-cov
      llvm-dwarfdump
      llvm-dwp
      llvm-lib
      llvm-nm
      llvm-objcopy
      llvm-pdbutil
      llvm-profdata
      llvm-ranlib
      llvm-readobj
      llvm-size
      llvm-strings
      llvm-strip
      llvm-symbolizer
      llvm-undname
      nm
      obj2yaml
      objcopy
      objdump
      ranlib
      readelf
      size
      strings
      yaml2obj
    CACHE STRING "")

set(CLANG_TOOLS
      clang
      clangd
      # clangd-indexer
      clang-format
      clang-headers
      clang-rename
      clang-reorder-fields
      clang-tidy
      modularize
    CACHE STRING "")

set(LLD_TOOLS
      lld
    CACHE STRING "")

if(NOT CMAKE_SYSTEM_NAME STREQUAL Windows)
  set(lldb_server lldb-server)
endif()

set(LLDB_TOOLS
      lldb
      lldb-vscode
      ${lldb_server}
    CACHE STRING "")

set(SWIFT_TOOLS
      swift
      swift-demangle
    CACHE STRING "")

set(LLVM_DISTRIBUTION_COMPONENTS
      LTO
      IndexStore
      libclang
      libclang-headers
      libclang-python-bindings
      liblldb
      #libtapi
      #sourcekit-inproc
      #swift-migrator-data
      #swift-headers
      #swift-clang-resource-dir-symlink
      #tapi-headers
      ${LLVM_TOOLCHAIN_TOOLS}
      ${CLANG_TOOLS}
      ${LLD_TOOLS}
      ${LLDB_TOOLS}
      ${SWIFT_TOOLS}
    CACHE STRING "")

# TODO(compnerd) port these to SWIFT_TOOLS to enable installation.
#   [x] autolink-driver
#   [x] compiler
#   [x] clang-resource-dir-symlink
#   [ ] editor-integration
#   [x] sourcekit-inproc
set(SWIFT_INSTALL_COMPONENTS
      autolink-driver
      compiler
      clang-resource-dir-symlink
      editor-integration
      sourcekit-inproc
    CACHE STRING "")

set(SWIFT_SDKS
      ""
    CACHE STRING "")

