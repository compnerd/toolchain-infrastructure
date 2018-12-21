
# --- target ---
# TODO(compnerd) mark primary builds because the build system is not ready for
# cross-compilation
set(SWIFT_PRIMARY_VARIANT_SDK WINDOWS CACHE STRING "")
set(SWIFT_PRIMARY_VARIANT_ARCH x86_64 CACHE STRING "")

# TODO(compnerd) define the SWIFT_HOST_VARIANT_* since the build system is not
# ready to disable tools
set(SWIFT_HOST_VARIANT_SDK NONE CACHE STRING "")
set(SWIFT_HOST_VARIANT_ARCH x86_64 CACHE STRING "")

# TODO(compnerd) specify a single architecture because the build system is not
# ready for the multi-architecture setup
set(SWIFT_SDK_WINDOWS_ARCHITECTURES x86_64 CACHE STRING "")

# --- libraries to use ---
set(SWIFT_WINDOWS_x86_64_ICU_UC_INCLUDE ${TOOLCHAIN_SOURCE_DIR}/build/thirdparty/icu/include/unicode CACHE STRING "")
set(SWIFT_WINDOWS_x86_64_ICU_UC ${TOOLCHAIN_SOURCE_DIR}/build/thirdparty/icu/lib/icuuc.lib CACHE STRING "")
set(SWIFT_WINDOWS_x86_64_ICU_I18N_INCLUDE ${TOOLCHAIN_SOURCE_DIR}/build/thirdparty/icu/include CACHE STRING "")
set(SWIFT_WINDOWS_x86_64_ICU_I18N ${TOOLCHAIN_SOURCE_DIR}/build/thirdparty/icu/lib/icuin.lib CACHE STRING "")

# --- SDKs ---
set(SWIFT_SDKS
      WINDOWS
    CACHE STRING "")

