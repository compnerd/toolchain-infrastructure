
set(CMAKE_C_COMPILER_TARGET x86_64-unknown-windows-msvc CACHE STRING "")

# TODO(compnerd) figure out how to break the cycle between XCTest and Foundation
set(ENABLE_TESTING NO CACHE BOOL "")

# --- libraries to use ---

# TODO(compnerd) build these from source
set(ICU_INCLUDE_DIR ${TOOLCHAIN_SOURCE_DIR}/build/thirdparty/icu/include CACHE STRING "")
set(ICU_I18N_LIBRARY ${TOOLCHAIN_SOURCE_DIR}/build/thirdparty/icu/lib/icuin.lib CACHE STRING "")
set(ICU_UC_LIBRARY ${TOOLCHAIN_SOURCE_DIR}/build/thirdparty/icu/lib/icuuc.lib CACHE STRING "")
set(ICU_LIBRARY ${TOOLCHAIN_SOURCE_DIR}/build/thirdparty/icu/lib/icuin.lib;${TOOLCHAIN_SOURCE_DIR}/build/thirdparty/icu/lib/icuuc.lib CACHE STRING "")

set(LIBXML2_INCLUDE_DIR ${TOOLCHAIN_SOURCE_DIR}/build/thirdparty/libxml2/include CACHE STRING "")
set(LIBXML2_LIBRARY ${TOOLCHAIN_SOURCE_DIR}/build/thirdparty/libxml2/lib/libxml2.lib CACHE STRING "")

set(CURL_INCLUDE_DIR ${TOOLCHAIN_SOURCE_DIR}/build/thirdparty/curl/include CACHE STRING "")
set(CURL_LIBRARY ${TOOLCHAIN_SOURCE_DIR}/build/thirdparty/curl/lib/libcurl.lib CACHE STRING "")

set(CMAKE_FIND_ROOT_PATH "/var/empty" CACHE STRING "")

