
# --- global ---
set(LLVM_ENABLE_PROJECTS
      clang
      clang-tools-extra
      lld
      lldb
      cmark
      swift
    CACHE STRING "")

set(LLVM_EXTERNAL_PROJECTS
      cmark
      swift
    CACHE STRING "")

# --- LLVM ---

if(CMAKE_BUILD_TYPE MATCHES Debug)
  set(PACKAGE_VENDOR "" CACHE STRING "")
else()
  set(PACKAGE_VENDOR "compnerd.org" CACHE STRING "")
endif()

# NOTE(compnerd) LLVM appends a VCS revision string to its package version,
# which we do not want.  We do not want the "svn" suffix on development
# toolchains to avoid churn.
set(LLVM_APPEND_VC_REV NO CACHE BOOL "")
set(LLVM_VERSION_SUFFIX "" CACHE STRING "")

# NOTE(compnerd) currently the x86 and ARM targets are the ones that we are
# building, so only enable the backends for those architectures.
set(LLVM_TARGETS_TO_BUILD AArch64 ARM X86 CACHE STRING "")

set(LLVM_INCLUDE_DOCS NO CACHE BOOL "")
set(LLVM_INCLUDE_EXAMPLES NO CACHE BOOL "")

# NOTE(compnerd) we do not use the GO bindings and the tests require additional
# dependencies which can cause the tests to not always work properly.
set(LLVM_INCLUDE_GO_TESTS NO CACHE BOOL "")

# NOTE(compnerd) we do not use the OCaml bindings
set(LLVM_ENABLE_OCAMLDOC NO CACHE BOOL "")

# NOTE(compnerd) disable the gold plugin as we currently use ld64 and lld.
# Eventually, it would be ideal to only have the lld linker as the universal
# linker.
set(LLVM_TOOL_GOLD_BUILD NO CACHE BOOL "")

# NOTE(compnerd) disable libxml2 usage.  This is needed for the manifest tool
# (llvm-mt).  Since this tool is not being used currently, avoid the setup for
# libxml2
set(LLVM_ENABLE_LIBXML2 NO CACHE BOOL "")

# FIXME(compnerd) we want to build compiler-rt as a runtimes project
set(LLVM_BUILD_EXTERNAL_COMPILER_RT NO)

# NOTE(compnerd) we use a shared version of LLVM across clang and swift.
# However, swift does not link the full version of LLVMSupport in the runtime,
# and thus we need to disable the ABI breaking checks.
set(LLVM_DISABLE_ABI_BREAKING_CHECKS_ENFORCING FORCE_OFF CACHE BOOL "")

# NOTE(compnerd) provide the handy symlinks for the toolnames without the llvm-
# prefix to make developers happy.
set(LLVM_INSTALL_BINUTILS_SYMLINKS YES CACHE BOOL "")

# NOTE(compnerd) we do not currently use the benchmark targets.  Disable target
# generation for now.
set(LLVM_INCLUDE_BENCHMARKS NO CACHE BOOL "")

# TODO(compnerd) setup the toolchain to ensure that the libedit that we use is
# available on all the targets and is reproducible.
set(LLVM_ENABLE_LIBEDIT YES CACHE BOOL "")

# XXX(compnerd) is libpfm useful for our builds?
set(LLVM_ENABLE_LIBPFM NO CACHE BOOL "")

# TODO(compnerd) setup the toolchain to ensure that the zlib that we use is
# available on all the targets and is reproducible.
set(LLVM_ENABLE_ZLIB YES CACHE BOOL "")

# NOTE(compnerd) use the modules build which can be a bit faster in practice.
if(CMAKE_C_COMPILER_ID MATCHES clang)
  set(LLVM_ENABLE_MODULES YES CACHE BOOL "")
endif()

# NOTE(compnerd) fission is significantly faster to link, so we should prefer to
# enable it.  This would be better if we could package it into a DWP.
#
# Disable it on Windows to avoid the unknown argument warning
if(CMAKE_SYSTEM_NAME STREQUAL Windows)
  set(LLVM_USE_SPLIT_DWARF NO CACHE BOOL "")
else()
  set(LLVM_USE_SPLIT_DWARF YES CACHE BOOL "")
endif()

# FIXME(compnerd) we do not enable polyhedra optimizations currently
set(LLVM_POLLY_LINK_INTO_TOOLS NO CACHE BOOL "")
set(LLVM_POLLY_BUILD NO CACHE BOOL "")

set(LLVM_ENABLE_PER_TARGET_RUNTIME_DIR YES CACHE BOOL "")

# --- clang ---

if(CMAKE_BUILD_TYPE MATCHES Debug)
  set(CLANG_VENDOR "" CACHE STRING "")
  set(CLANG_VENDOR_UTI "" CACHE STRING "")
else()
  set(CLANG_VENDOR "compnerd.org" CACHE STRING "")
  set(CLANG_VENDOR_UTI org.compnerd.clang CACHE STRING "")
endif()

# NOTE(compnerd) create the symlinks for the traditional Unix C/C++/C
# Preprocessor drivers (cc, c++, cpp).  Create expected entries for clang,
# clang++, and clang-cpp to mirror GCC's behaviour.  Create the clang-cl driver
# link to allow cross-compilation to Windows.
set(CLANG_LINKS_TO_CREATE cc c++ cpp clang++ clang-cpp clang-cl CACHE STRING "")

# NOTE(compnerd) support loading plugins into the compiler to enable additional
# tooling when using the toolchain.
set(CLANG_PLUGIN_SUPPORT ON CACHE BOOL "")

# NOTE(compnerd) embed a build id by default in the artifacts generated by the
# compiler.  This allows for production builds to save the debug information and
# tie it to the version.
set(ENABLE_LINKER_BUILD_ID YES CACHE BOOL "")

# NOTE(compnerd) releax relocations by default.  This can allow fewer
# relocations which in turn results in faster links.
set(ENABLE_X86_RELAX_RELOCATIONS YES CACHE BOOL "")

# NOTE(compnerd) this controls the versions of python that are populated for the
# libclang python bindings
set(CLANG_PYTHON_BINDINGS_VERSIONS 2.7 CACHE STRING "")

# TODO(compnerd) setup the toolchain to ensure that the Z3 that we use is
# available on all the targets and is reproducible
set(CLANG_ANALYZER_ENABLE_Z3_SOLVER NO CACHE BOOL "")

# TODO(compnerd) ensure that we get the revisions for all components to identify
# the build sufficiently to know that the build is different
# set(CLANG_REPOSITORY_STRING "llvm: ${LLVM_REVISION}, cfe: ${CFE_REVISION}, lld: ${LLD_REVISION}" CACHE STRING "")

# --- lld ---

# NOTE(compnerd) build similarly across all hosts
set(LLD_USE_VTUNE NO CACHE BOOL "")

# --- lldb ---

# TODO(compnerd) setup the toolchain to ensure that the libedit that we use is
# available on all the targets and is reproducible.
set(LLDB_DISABLE_LIBEDIT YES CACHE BOOL "")

# TODO(compnerd) setup the toolchain to ensure that the python and swig that we
# use is available on all the targets and is reproducible.
set(LLDB_DISABLE_PYTHON YES CACHE BOOL "")

# TODO(compnerd) setup the toolchain to ensure that the ncurses that we use is
# available on all the targets and is reproducible.
set(LLDB_DISABLE_CURSES YES CACHE BOOL "")

# NOTE(compnerd) allow PYTHONHOME to be used to find python for lldb
set(LLDB_RELOCATABLE_PYTHON YES CACHE BOOL "")

# NOTE(compnerd) do not provide a new six.py package in the toolchain
set(LLDB_USE_SYSTEM_SIX YES CACHE BOOL "")

# --- swift ---

# NOTE(compnerd) build with the lld linker rather than the gold linker.
set(SWIFT_ENABLE_GOLD_LINKER NO CACHE BOOL "")
set(SWIFT_ENABLE_LLD_LINKER YES CACHE BOOL "")

# NOTE(compnerd) build the swift tools to populate them into the toolchain.
set(SWIFT_INCLUDE_TOOLS YES CACHE BOOL "")

# NOTE(compnerd) disable building the documentation as we do not wish to push
# tht into the toolchain.
set(SWIFT_INCLUDE_DOCS NO CACHE BOOL "")

# NOTE(compnerd) disable the standard library, this is part of the target which
# will be built separately.
set(SWIFT_BUILD_DYNAMIC_STDLIB NO CACHE BOOL "")
set(SWIFT_BUILD_STATIC_STDLIB NO CACHE BOOL "")

# NOTE(lanza) the lldb framework requires the clang headers that do not get
# installed unless the stdlib is build
if(SWIFT_BUILD_DYNAMIC_STDLIB OR SWIFT_BUILD_STATIC_STDLIB AND
    CMAKE_HOST_SYSTEM_NAME STREQUAL Darwin)
  set(LLDB_BUILD_FRAMEWORK YES CACHE BOOL "")
else()
  set(LLDB_BUILD_FRAMEWORK NO CACHE BOOL "")
endif()

# NOTE(compnerd) disable the SDK overlay, this is part of the target which will
# be built separately.
set(SWIFT_BUILD_DYNAMIC_SDK_OVERLAY NO CACHE BOOL "")
set(SWIFT_BUILD_STATIC_SDK_OVERLAY NO CACHE BOOL "")

# NOTE(compnerd) we need to build the remote mirror for the debugger
set(SWIFT_BUILD_REMOTE_MIRROR YES CACHE BOOL "")

# NOTE(compnerd) build SourceKit to enable IDE integration tools.
set(SWIFT_BUILD_SOURCEKIT YES CACHE BOOL "")

