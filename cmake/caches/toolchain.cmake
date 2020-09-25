
set(LLVM_TOOLCHAIN_TOOLS
      addr2line
      ar
      c++filt
      dsymutil
      dwp
      # lipo
      llvm-ar
      llvm-cov
      llvm-cvtres
      llvm-cxxfilt
      llvm-dlltool
      llvm-dwarfdump
      llvm-dwp
      llvm-lib
      llvm-lipo
      llvm-mt
      llvm-nm
      llvm-objcopy
      llvm-objdump
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
      objcopy
      objdump
      ranlib
      readelf
      size
      strings
    CACHE STRING "")

set(CLANG_TOOLS
      clang
      clangd
      # clangd-indexer
      clang-format
      clang-resource-headers
      # clang-rename
      # clang-reorder-fields
      clang-tidy
      # modularize
    CACHE STRING "")

set(LLD_TOOLS
      lld
    CACHE STRING "")

set(LLDB_TOOLS
      liblldb
      lldb
      lldb-argdumper
      lldb-server
      lldb-vscode
      repl_swift
    CACHE STRING "")

set(SWIFT_INSTALL_COMPONENTS
      autolink-driver
      compiler
      clang-resource-dir-symlink
      editor-integration
      sourcekit-inproc
    CACHE STRING "")

set(LLVM_DISTRIBUTION_COMPONENTS
      LTO
      IndexStore
      libclang
      libclang-headers
      libclang-python-bindings
      #libtapi
      #tapi-headers
      ${LLVM_TOOLCHAIN_TOOLS}
      ${CLANG_TOOLS}
      ${LLD_TOOLS}
      ${LLDB_TOOLS}
      ${SWIFT_INSTALL_COMPONENTS}
    CACHE STRING "")
