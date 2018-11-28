# NOTE(compnerd) always build using the lld linker
set(USE_LLD_LINKER YES CACHE BOOL "")

set(CMAKE_C_COMPILER_TARGET x86_64-unknown-windows-msvc CACHE STRING "")

# NOTE(compnerd) we need to override the include order for the Windows SDK to
# accomodate the conflicts with the compiler resource dir and promote the SDK to
# system level.  The include ordering is important to the construction of the
# modules for building libdispatch.  Note that `-internal-isystem` is not a
# driver level flag, so we need to pass that through the C compiler frontend
# (which is guaranteed to be clang).  So, we end up using `-Xcc` to pass a flag
# to the driver that passes through the C driver to the compiler (`-Xclang`).
set(CMAKE_SWIFT_FLAGS -Xcc -Xclang -Xcc -internal-isystem -Xcc -Xclang -Xcc $ENV{VCToolsInstallDir}/include -Xcc -Xclang -Xcc -internal-isystem -Xcc -Xclang -Xcc $ENV{UniversalCRTSdkDir}/Include/$ENV{UCRTVersion}/ucrt CACHE STRING "")

set(ENABLE_SWIFT YES CACHE BOOL "")

# TODO(compnerd) port the unit tests to Windows
set(ENABLE_TESTING NO CACHE BOOL "")

