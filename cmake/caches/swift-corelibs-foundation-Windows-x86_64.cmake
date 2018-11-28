
set(CMAKE_C_COMPILER_TARGET x86_64-unknown-windows-msvc CACHE STRING "")

# TODO(compnerd) figure out how to break the cycle between XCTest and Foundation
set(ENABLE_TESTING NO CACHE BOOL "")

# --- libraries to use ---

# TODO(compnerd) build these from source
set(ICU_ROOT ${TOOLCHAIN_SOURCE_DIR}/build/icu-59.1-vs2017 CACHE STRING "")
set(LIBXML2_LIBRARY ${TOOLCHAIN_SOURCE_DIR}/build/libxml2-2.9.2/lib/libxml2.dll.a CACHE STRING "")

set(CMAKE_FIND_ROOT_PATH "/var/empty" CACHE STRING "")

