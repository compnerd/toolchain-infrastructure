
set(CMAKE_C_COMPILER_TARGET x86_64-unknown-windows-msvc CACHE STRING "")

# TODO(compnerd) figure out how to break the cycle between XCTest and Foundation
set(ENABLE_TESTING NO CACHE BOOL "")

# NOTE(compnerd) we need to override the include order for the Windows SDK to
# accomodate the conflicts with the compiler resource dir and promote the SDK to
# system level.  The include ordering is important to the construction of the
# modules for building libdispatch.  Note that `-internal-isystem` is not a
# driver level flag, so we need to pass that through the C compiler frontend
# (which is guaranteed to be clang).  So, we end up using `-Xcc` to pass a flag
# to the driver that passes through the C driver to the compiler (`-Xclang`).
set(CMAKE_SWIFT_FLAGS -Xcc -Xclang -Xcc -ivfsoverlay -Xcc -Xclang -Xcc ${CMAKE_BINARY_DIR}/windows-sdk-vfs-overlay.yaml -Xcc -Xclang -Xcc -internal-isystem -Xcc -Xclang -Xcc $ENV{VCToolsInstallDir}/include -Xcc -Xclang -Xcc -internal-isystem -Xcc -Xclang -Xcc $ENV{UniversalCRTSdkDir}/Include/$ENV{UCRTVersion}/ucrt -Xcc -Xclang -Xcc -internal-isystem -Xcc -Xclang -Xcc $ENV{UniversalCRTSdkDir}/Include/$ENV{UCRTVersion}/um -Xcc -Xclang -Xcc -internal-isystem -Xcc -Xclang -Xcc $ENV{UniversalCRTSdkDir}/Include/$ENV{UCRTVersion}/shared CACHE STRING "")

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

