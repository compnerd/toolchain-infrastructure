if(${USE_BOOTSTRAP_TOOLCHAIN})
  include("${CMAKE_CURRENT_LIST_DIR}/../modules/BootstrapToolchain.cmake")
  set(DARWIN_TARGET x86_64-apple-macosx)
endif ()

set(LLVM_BUILTIN_TARGETS
      aarch64-unknown-linux-gnu
      aarch64-unknown-linux-android
      armv7-unknown-linux-androideabi
      armv7-unknown-linux-gnueabi
      armv7-unknown-linux-gnueabihf
      i386-unknown-linux-gnu
      x86_64-unknown-linux-gnu
      x86_64-unknown-windows-msvc
      aarch64-unknown-fuchsia
      x86_64-unknown-fuchsia
      x86_64-apple-macosx
    CACHE STRING "")

set(LLVM_RUNTIME_TARGETS
      aarch64-unknown-linux-gnu
      aarch64-unknown-linux-android
      armv7-unknown-linux-androideabi
      armv7-unknown-linux-gnueabi
      armv7-unknown-linux-gnueabihf
      i386-unknown-linux-gnu
      x86_64-unknown-linux-gnu
      x86_64-unknown-windows-msvc
      aarch64-unknown-fuchsia
      x86_64-unknown-fuchsia
      ${DARWIN_TARGET}
    CACHE STRING "")


set(target x86_64-apple-macosx)
set(BUILTINS_${target}_CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSTEM_NAME Darwin CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSTEM_PROCESSOR arm64 CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSROOT "${TOOLCHAIN_SOURCE_DIR}/external/DarwinSDK/xcode_10.3.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk" CACHE STRING "")
set(BUILTINS_${target}_CMAKE_C_FLAGS "" CACHE STRING "")
set(BUILTINS_${target}_CMAKE_LIPO "${LLVM_BUILD_DIR}/bin/llvm-lipo" CACHE STRING "")
set(BUILTINS_${target}_DARWIN_macosx_CACHED_SYSROOT "${TOOLCHAIN_SOURCE_DIR}/external/DarwinSDK/xcode_10.3.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk" CACHE STRING "")
set(BUILTINS_${target}_DARWIN_iphoneos_CACHED_SYSROOT "${TOOLCHAIN_SOURCE_DIR}/external/DarwinSDK/xcode_10.3.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk" CACHE STRING "")
set(BUILTINS_${target}_DARWIN_iphonesimulator_CACHED_SYSROOT "${TOOLCHAIN_SOURCE_DIR}/external/DarwinSDK/xcode_10.3.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk" CACHE STRING "")
set(BUILTINS_${target}_COMPILER_RT_ENABLE_IOS "ON" CACHE STRING "")
set(BUILTINS_${target}_DARWIN_osx_BUILTIN_ARCHS "x86_64|x86_64h" CACHE STRING "")
set(BUILTINS_${target}_DARWIN_ios_BUILTIN_ARCHS "armv7|armv7k|armv7s|arm64" CACHE STRING "")
set(BUILTINS_${target}_DARWIN_iossim_BUILTIN_ARCHS "i386|x86_64|x86_64h" CACHE STRING "")

set(RUNTIMES_${target}_CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SYSTEM_NAME Darwin CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SHARED_LINKER_FLAGS "-fuse-ld=ld64" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_MODULE_LINKER_FLAGS "-fuse-ld=ld64" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_EXE_LINKER_FLAGS "-fuse-ld=ld64" CACHE STRING "")
set(RUNTIMES_${target}_LLVM_ENABLE_ASSERTIONS ON CACHE BOOL "")
set(RUNTIMES_${target}_SANITIZER_CXX_ABI "libc++" CACHE STRING "")
set(RUNTIMES_${target}_SANITIZER_CXX_ABI_INTREE ON CACHE BOOL "")
set(RUNTIMES_${target}_CMAKE_C_FLAGS "" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_CXX_FLAGS "" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_LIPO "${LLVM_BUILD_DIR}/bin/llvm-lipo" CACHE STRING "")
set(RUNTIMES_${target}_DARWIN_macosx_CACHED_SYSROOT "${TOOLCHAIN_SOURCE_DIR}/external/DarwinSDK/xcode_10.3.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk" CACHE STRING "")
set(RUNTIMES_${target}_DARWIN_iphoneos_CACHED_SYSROOT "${TOOLCHAIN_SOURCE_DIR}/external/DarwinSDK/xcode_10.3.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk" CACHE STRING "")
set(RUNTIMES_${target}_DARWIN_iphonesimulator_CACHED_SYSROOT "${TOOLCHAIN_SOURCE_DIR}/external/DarwinSDK/xcode_10.3.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk" CACHE STRING "")
set(RUNTIMES_${target}_DARWIN_macosx_SYSROOT "${TOOLCHAIN_SOURCE_DIR}/external/DarwinSDK/xcode_10.3.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk" CACHE STRING "")
set(RUNTIMES_${target}_DARWIN_iphoneos_SYSROOT "${TOOLCHAIN_SOURCE_DIR}/external/DarwinSDK/xcode_10.3.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk" CACHE STRING "")
set(RUNTIMES_${target}_DARWIN_iphonesimulator_SYSROOT "${TOOLCHAIN_SOURCE_DIR}/external/DarwinSDK/xcode_10.3.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk" CACHE STRING "")
set(RUNTIMES_${target}_COMPILER_RT_ENABLE_IOS "ON" CACHE STRING "")
set(RUNTIMES_${target}_COMPILER_RT_SANITIZERS_TO_BUILD "asan;cfi;tsan;ubsan_minimal" CACHE STRING "")
set(RUNTIMES_${target}_COMPILER_RT_BUILD_SANITIZERS OFF CACHE BOOL "")
set(RUNTIMES_${target}_COMPILER_RT_BUILD_PROFILE OFF CACHE BOOL "")
# TODO(t48839194) - isystem for xray needs to be added to not break Fuchsia
set(RUNTIMES_${target}_COMPILER_RT_BUILD_XRAY OFF CACHE BOOL "")
# Set `TEST_COMPILE_ONLY` to prevent the runtimes configure from ensuring that
# the compiler works, we do not have xcodebuild on Linux, and that is used to
# verify the SDK version to disable the x86 builds which are no longer supported
# as of 10.15.
set(RUNTIMES_${target}_TEST_COMPILE_ONLY ON CACHE BOOL "")


set(target aarch64-unknown-fuchsia)
set(BUILTINS_${target}_CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSTEM_NAME Fuchsia CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSTEM_PROCESSOR aarch64 CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSROOT "" CACHE STRING "")
set(BUILTINS_${target}_CMAKE_C_FLAGS "-isystem ${TOOLCHAIN_SOURCE_DIR}/sysroots/fuchsia/arch/arm64/sysroot/include" CACHE STRING "")
set(BUILTINS_${target}_LLVM_ENABLE_PER_TARGET_RUNTIME_DIR NO CACHE BOOL "")

set(RUNTIMES_${target}_CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SYSTEM_NAME Fuchsia CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SYSTEM_PROCESSOR aarch64 CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SYSROOT "${TOOLCHAIN_SOURCE_DIR}/sysroots/fuchsia/arch/arm64/sysroot" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_C_FLAGS "-isystem ${TOOLCHAIN_SOURCE_DIR}/sysroots/fuchsia/arch/arm64/sysroot/include" CACHE STRING "")
set(RUNTIMES_${target}_LIBCXX_USE_COMPILER_RT YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXXABI_USE_LLVM_UNWINDER YES CACHE BOOL "")
set(RUNTIMES_${target}_COMPILER_RT_BUILD_LIBFUZZER NO CACHE BOOL "")


set(target x86_64-unknown-fuchsia)
set(BUILTINS_${target}_CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSTEM_NAME Fuchsia CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSTEM_PROCESSOR x86_64 CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSROOT "" CACHE STRING "")
set(BUILTINS_${target}_CMAKE_C_FLAGS "-isystem ${TOOLCHAIN_SOURCE_DIR}/sysroots/fuchsia/arch/x64/sysroot/include" CACHE STRING "")
set(BUILTINS_${target}_LLVM_ENABLE_PER_TARGET_RUNTIME_DIR NO CACHE BOOL "")

set(RUNTIMES_${target}_CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SYSTEM_NAME Fuchsia CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SYSTEM_PROCESSOR x86_64 CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SYSROOT "${TOOLCHAIN_SOURCE_DIR}/sysroots/fuchsia/arch/x64/sysroot" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_C_FLAGS "-isystem ${TOOLCHAIN_SOURCE_DIR}/sysroots/fuchsia/arch/x64/sysroot/include" CACHE STRING "")
set(RUNTIMES_${target}_LIBCXX_USE_COMPILER_RT YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXXABI_USE_LLVM_UNWINDER YES CACHE BOOL "")
set(RUNTIMES_${target}_COMPILER_RT_BUILD_LIBFUZZER NO CACHE BOOL "")


set(target aarch64-unknown-linux-gnu)
set(BUILTINS_${target}_CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSTEM_NAME Linux CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSTEM_PROCESSOR aarch64 CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSROOT "${TOOLCHAIN_SOURCE_DIR}/sysroots/linux-aarch64" CACHE STRING "")
set(BUILTINS_${target}_CMAKE_C_FLAGS "" CACHE STRING "")
set(BUILTINS_${target}_LLVM_ENABLE_PER_TARGET_RUNTIME_DIR NO CACHE BOOL "")

set(RUNTIMES_${target}_CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SYSTEM_NAME Linux CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SYSROOT "${TOOLCHAIN_SOURCE_DIR}/sysroots/linux-aarch64" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SHARED_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_MODULE_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_EXE_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")
set(RUNTIMES_${target}_LLVM_ENABLE_ASSERTIONS ON CACHE BOOL "")
set(RUNTIMES_${target}_SANITIZER_CXX_ABI "libc++" CACHE STRING "")
set(RUNTIMES_${target}_SANITIZER_CXX_ABI_INTREE ON CACHE BOOL "")
set(RUNTIMES_${target}_CMAKE_C_FLAGS "" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_CXX_FLAGS "" CACHE STRING "")
set(RUNTIMES_${target}_COMPILER_RT_SANITIZERS_TO_BUILD "asan;cfi;tsan;ubsan_minimal" CACHE STRING "")
# TODO(t48839194) - isystem for xray needs to be added to not break Fuchsia
set(RUNTIMES_${target}_COMPILER_RT_BUILD_XRAY OFF CACHE BOOL "")


set(target aarch64-unknown-linux-android)
set(BUILTINS_${target}_CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "")
set(BUILTINS_${target}_CMAKE_C_FLAGS "-isystem ${TOOLCHAIN_SOURCE_DIR}/sysroots/android-aarch64/usr/include/aarch64-linux-android -D__ANDROID_API__=15" CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSROOT "${TOOLCHAIN_SOURCE_DIR}/sysroots/android-aarch64" CACHE STRING "")
# TODO(abdulras) replace with Android when we can replace the sysroot
set(BUILTINS_${target}_CMAKE_SYSTEM_NAME Linux CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSTEM_PROCESSOR aarch64 CACHE STRING "")
set(BUILTINS_${target}_CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY CACHE STRING "")
set(BUILTINS_${target}_ANDROID YES CACHE BOOL "")
set(BUILTINS_${target}_LLVM_ENABLE_PER_TARGET_RUNTIME_DIR NO CACHE BOOL "")

set(RUNTIMES_${target}_CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "")
# TODO(abdulras) replace with Android when we can replace the sysroot
set(RUNTIMES_${target}_CMAKE_SYSTEM_NAME Linux CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SYSROOT "${TOOLCHAIN_SOURCE_DIR}/sysroots/android-aarch64" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SHARED_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_MODULE_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_EXE_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")
set(RUNTIMES_${target}_LLVM_ENABLE_ASSERTIONS ON CACHE BOOL "")
set(RUNTIMES_${target}_SANITIZER_CXX_ABI "libc++" CACHE STRING "")
set(RUNTIMES_${target}_SANITIZER_CXX_ABI_INTREE ON CACHE BOOL "")
set(RUNTIMES_${target}_CMAKE_SYSROOT "${TOOLCHAIN_SOURCE_DIR}/sysroots/android-aarch64" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_C_FLAGS   "-D__ANDROID_API__=21" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_CXX_FLAGS "-D__ANDROID_API__=21" CACHE STRING "")
set(RUNTIMES_${target}_COMPILER_RT_SANITIZERS_TO_BUILD "asan;cfi;tsan;ubsan_minimal" CACHE STRING "")
# TODO(t48839194) - isystem for xray needs to be added to not break Fuchsia
set(RUNTIMES_${target}_COMPILER_RT_BUILD_XRAY OFF CACHE BOOL "")
set(RUNTIMES_${target}_CMAKE_SIZEOF_VOID_P 8 CACHE STRING "")
set(RUNTIMES_${target}_ANDROID TRUE CACHE BOOL "")
set(RUNTIMES_${target}_ANDROID_NATIVE_API_LEVEL 21 CACHE STRING "")
set(RUNTIMES_${target}_LIBCXX_CXX_ABI_LIBNAME "libcxxabi" CACHE STRING "")
set(RUNTIMES_${target}_LIBCXX_CXX_ABI_INTREE ON CACHE BOOL "")
set(RUNTIMES_${target}_LIBUNWIND_HAS_C_LIB YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBUNWIND_HAS_DL_LIB YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBUNWIND_ENABLE_SHARED YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBUNWIND_SUPPORTS_FNO_EXCEPTIONS_FLAG YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBUNWIND_SUPPORTS_FUNWIND_TABLES_FLAG YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXXABI_ENABLE_SHARED NO CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXXABI_HAS_C_LIB YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXXABI_HAS_NOSTDINCXX_FLAG YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXXABI_USE_LLVM_UNWINDER YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXX_ENABLE_ABI_LINKER_SCRIPT NO CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXX_ENABLE_STATIC_ABI_LIBRARY YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXX_ENABLE_STATIC NO CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXX_HAS_C_LIB YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXX_STATICALLY_LINK_ABI_IN_SHARED_LIBRARY YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXX_USE_COMPILER_RT YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXX_SUPPORTS_NODEFAULTLIBS_FLAG YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXX_HAS_COMMENT_LIB_PRAGMA NO CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXXABI_USE_COMPILER_RT YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBUNWIND_USE_COMPILER_RT YES CACHE BOOL "")


set(target armv7-unknown-linux-androideabi)
set(BUILTINS_${target}_CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "")
set(BUILTINS_${target}_CMAKE_C_FLAGS "-march=armv7 -mthumb -isystem ${TOOLCHAIN_SOURCE_DIR}/sysroots/android-arm/usr/include/arm-linux-androideabi -D__ANDROID_API__=15" CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSROOT "${TOOLCHAIN_SOURCE_DIR}/sysroots/android-arm" CACHE STRING "")
# TODO(abdulras) replace with Android when we can replace the sysroot
set(BUILTINS_${target}_CMAKE_SYSTEM_NAME Linux CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSTEM_PROCESSOR armv7 CACHE STRING "")
set(BUILTINS_${target}_LLVM_ENABLE_PER_TARGET_RUNTIME_DIR NO CACHE BOOL "")
set(BUILTINS_${target}_ANDROID YES CACHE BOOL "")
set(BUILTINS_${target}_CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY CACHE STRING "")

set(RUNTIMES_${target}_CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "")
# TODO(abdulras) can this use the `Android` SYSTEM_NAME?
set(RUNTIMES_${target}_CMAKE_SYSTEM_NAME Linux CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SYSROOT "${TOOLCHAIN_SOURCE_DIR}/sysroots/android-arm" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SHARED_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_MODULE_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_EXE_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")
set(RUNTIMES_${target}_LLVM_ENABLE_ASSERTIONS ON CACHE BOOL "")
set(RUNTIMES_${target}_SANITIZER_CXX_ABI "libc++" CACHE STRING "")
set(RUNTIMES_${target}_SANITIZER_CXX_ABI_INTREE ON CACHE BOOL "")
set(RUNTIMES_${target}_CMAKE_SYSROOT "${TOOLCHAIN_SOURCE_DIR}/sysroots/android-arm" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_C_FLAGS   "-march=armv7 -mthumb -isystem ${TOOLCHAIN_SOURCE_DIR}/sysroots/android-arm/usr/include/arm-linux-androideabi -D__ANDROID_API__=15" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_CXX_FLAGS "-march=armv7 -mthumb -isystem ${TOOLCHAIN_SOURCE_DIR}/sysroots/android-arm/usr/include/arm-linux-androideabi -D__ANDROID_API__=15" CACHE STRING "")
set(RUNTIMES_${target}_COMPILER_RT_SANITIZERS_TO_BUILD "asan;cfi;tsan;ubsan_minimal" CACHE STRING "")
# TODO(t48839194) - isystem for xray needs to be added to not break Fuchsia
set(RUNTIMES_${target}_COMPILER_RT_BUILD_XRAY OFF CACHE BOOL "")
set(RUNTIMES_${target}_CMAKE_SIZEOF_VOID_P 4 CACHE STRING "")
set(RUNTIMES_${target}_ANDROID TRUE CACHE BOOL "")
set(RUNTIMES_${target}_ANDROID_NATIVE_API_LEVEL 15 CACHE STRING "")
set(RUNTIMES_${target}_LIBCXX_CXX_ABI_LIBNAME "libcxxabi" CACHE STRING "")
set(RUNTIMES_${target}_LIBCXX_CXX_ABI_INTREE ON CACHE BOOL "")
set(RUNTIMES_${target}_LIBUNWIND_HAS_C_LIB YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBUNWIND_HAS_DL_LIB YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBUNWIND_ENABLE_SHARED YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBUNWIND_SUPPORTS_FNO_EXCEPTIONS_FLAG YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBUNWIND_SUPPORTS_FUNWIND_TABLES_FLAG YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXXABI_ENABLE_SHARED NO CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXXABI_HAS_C_LIB YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXXABI_HAS_NOSTDINCXX_FLAG YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXXABI_USE_LLVM_UNWINDER YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXX_ENABLE_ABI_LINKER_SCRIPT NO CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXX_ENABLE_STATIC_ABI_LIBRARY YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXX_ENABLE_STATIC NO CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXX_ENABLE_FILESYSTEM NO CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXX_HAS_C_LIB YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXX_STATICALLY_LINK_ABI_IN_SHARED_LIBRARY YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXX_USE_COMPILER_RT YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXX_SUPPORTS_NODEFAULTLIBS_FLAG YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXX_HAS_COMMENT_LIB_PRAGMA NO CACHE BOOL "")
set(RUNTIMES_${target}_LIBCXXABI_USE_COMPILER_RT YES CACHE BOOL "")
set(RUNTIMES_${target}_LIBUNWIND_USE_COMPILER_RT YES CACHE BOOL "")


set(target armv7-unknown-linux-gnueabi)
set(BUILTINS_${target}_CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSTEM_NAME Linux CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSTEM_PROCESSOR armv7 CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSROOT "${TOOLCHAIN_SOURCE_DIR}/sysroots/linux-armel" CACHE STRING "")
set(BUILTINS_${target}_CMAKE_C_FLAGS "-march=armv7 -mthumb -mfloat-abi=soft" CACHE STRING "")
set(BUILTINS_${target}_LLVM_ENABLE_PER_TARGET_RUNTIME_DIR NO CACHE BOOL "")

set(RUNTIMES_${target}_CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SYSTEM_NAME Linux CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SYSROOT "${TOOLCHAIN_SOURCE_DIR}/sysroots/linux-armel" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SHARED_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_MODULE_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_EXE_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")
set(RUNTIMES_${target}_LLVM_ENABLE_ASSERTIONS ON CACHE BOOL "")
set(RUNTIMES_${target}_SANITIZER_CXX_ABI "libc++" CACHE STRING "")
set(RUNTIMES_${target}_SANITIZER_CXX_ABI_INTREE ON CACHE BOOL "")
set(RUNTIMES_${target}_CMAKE_C_FLAGS "" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_CXX_FLAGS "" CACHE STRING "")
set(RUNTIMES_${target}_COMPILER_RT_SANITIZERS_TO_BUILD "asan;cfi;tsan;ubsan_minimal" CACHE STRING "")
# TODO(t48839194) - isystem for xray needs to be added to not break Fuchsia
set(RUNTIMES_${target}_COMPILER_RT_BUILD_XRAY OFF CACHE BOOL "")


set(target armv7-unknown-linux-gnueabihf)
set(BUILTINS_${target}_CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSTEM_NAME Linux CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSTEM_PROCESSOR armv7 CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSROOT "${TOOLCHAIN_SOURCE_DIR}/sysroots/linux-armhf" CACHE STRING "")
set(BUILTINS_${target}_CMAKE_C_FLAGS "-march=armv7 -mthumb -mfloat-abi=hard" CACHE STRING "")
set(BUILTINS_${target}_LLVM_ENABLE_PER_TARGET_RUNTIME_DIR NO CACHE BOOL "")

set(RUNTIMES_${target}_CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SYSTEM_NAME Linux CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SYSROOT "${TOOLCHAIN_SOURCE_DIR}/sysroots/linux-armhf" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SHARED_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_MODULE_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_EXE_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")
set(RUNTIMES_${target}_LLVM_ENABLE_ASSERTIONS ON CACHE BOOL "")
set(RUNTIMES_${target}_SANITIZER_CXX_ABI "libc++" CACHE STRING "")
set(RUNTIMES_${target}_SANITIZER_CXX_ABI_INTREE ON CACHE BOOL "")
set(RUNTIMES_${target}_CMAKE_C_FLAGS "" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_CXX_FLAGS "" CACHE STRING "")
set(RUNTIMES_${target}_COMPILER_RT_SANITIZERS_TO_BUILD "asan;cfi;tsan;ubsan_minimal" CACHE STRING "")
# TODO(t48839194) - isystem for xray needs to be added to not break Fuchsia
set(RUNTIMES_${target}_COMPILER_RT_BUILD_XRAY OFF CACHE BOOL "")


set(target i386-unknown-linux-gnu)
set(BUILTINS_${target}_CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSTEM_NAME Linux CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSTEM_PROCESSOR i386 CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSROOT "${TOOLCHAIN_SOURCE_DIR}/sysroots/linux-x86" CACHE STRING "")
set(BUILTINS_${target}_CMAKE_C_FLAGS "-march=i386" CACHE STRING "")
set(BUILTINS_${target}_LLVM_ENABLE_PER_TARGET_RUNTIME_DIR NO CACHE BOOL "")

set(RUNTIMES_${target}_CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SYSTEM_NAME Linux CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SYSROOT "${TOOLCHAIN_SOURCE_DIR}/sysroots/linux-x86" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SHARED_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_MODULE_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_EXE_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")
set(RUNTIMES_${target}_LLVM_ENABLE_ASSERTIONS ON CACHE BOOL "")
set(RUNTIMES_${target}_SANITIZER_CXX_ABI "libc++" CACHE STRING "")
set(RUNTIMES_${target}_SANITIZER_CXX_ABI_INTREE ON CACHE BOOL "")
set(RUNTIMES_${target}_CMAKE_C_FLAGS "" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_CXX_FLAGS "" CACHE STRING "")
set(RUNTIMES_${target}_COMPILER_RT_SANITIZERS_TO_BUILD "asan;cfi;tsan;ubsan_minimal" CACHE STRING "")
# TODO(t48839194) - isystem for xray needs to be added to not break Fuchsia
set(RUNTIMES_${target}_COMPILER_RT_BUILD_XRAY OFF CACHE BOOL "")


set(target x86_64-unknown-linux-gnu)
set(BUILTINS_${target}_CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSTEM_NAME Linux CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSTEM_PROCESSOR x86_64 CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSROOT "${TOOLCHAIN_SOURCE_DIR}/sysroots/linux-x86_64" CACHE STRING "")
set(BUILTINS_${target}_CMAKE_C_FLAGS "" CACHE STRING "")
set(BUILTINS_${target}_LLVM_ENABLE_PER_TARGET_RUNTIME_DIR NO CACHE BOOL "")

set(RUNTIMES_${target}_CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SYSTEM_NAME Linux CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SYSROOT "${TOOLCHAIN_SOURCE_DIR}/sysroots/linux-x86_64" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SHARED_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_MODULE_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_EXE_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")
set(RUNTIMES_${target}_LLVM_ENABLE_ASSERTIONS ON CACHE BOOL "")
set(RUNTIMES_${target}_SANITIZER_CXX_ABI "libc++" CACHE STRING "")
set(RUNTIMES_${target}_SANITIZER_CXX_ABI_INTREE ON CACHE BOOL "")
set(RUNTIMES_${target}_CMAKE_C_FLAGS "" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_CXX_FLAGS "" CACHE STRING "")
set(RUNTIMES_${target}_COMPILER_RT_SANITIZERS_TO_BUILD "asan;cfi;tsan;ubsan_minimal" CACHE STRING "")
# TODO(t48839194) - isystem for xray needs to be added to not break Fuchsia
set(RUNTIMES_${target}_COMPILER_RT_BUILD_XRAY OFF CACHE BOOL "")


set(target x86_64-unknown-windows-msvc)
set(BUILTINS_${target}_CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSTEM_NAME Windows CACHE STRING "")
set(BUILTINS_${target}_CMAKE_TOOLCHAIN_FILE "${CMAKE_CURRENT_LIST_DIR}/../toolchains/Toolchain-Windows-x86_64.cmake" CACHE FILEPATH "")
set(BUILTINS_${target}_LLVM_ENABLE_PER_TARGET_RUNTIME_DIR NO CACHE BOOL "")

set(RUNTIMES_${target}_CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SYSTEM_NAME Windows CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SYSROOT "" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_SHARED_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_MODULE_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_EXE_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")
set(RUNTIMES_${target}_SANITIZER_CXX_ABI "libc++" CACHE STRING "")
set(RUNTIMES_${target}_LLVM_ENABLE_ASSERTIONS ON CACHE BOOL "")
set(RUNTIMES_${target}_SANITIZER_CXX_ABI_INTREE ON CACHE BOOL "")
set(RUNTIMES_${target}_CMAKE_C_FLAGS "-Xclang -fno-split-cold-code" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_CXX_FLAGS "-Xclang -fno-split-cold-code" CACHE STRING "")
set(RUNTIMES_${target}_COMPILER_RT_SANITIZERS_TO_BUILD "asan;cfi;tsan;ubsan_minimal" CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_TOOLCHAIN_FILE "${CMAKE_CURRENT_LIST_DIR}/../toolchains/Toolchain-Windows-x86_64.cmake" CACHE FILEPATH "")
# TODO(t48839194) - isystem for xray needs to be added to not break Fuchsia
set(RUNTIMES_${target}_COMPILER_RT_BUILD_XRAY OFF CACHE BOOL "")
set(RUNTIMES_${target}_LLVM_ENABLE_RUNTIMES "libcxx;compiler-rt" CACHE STRING "")


# ensure that all required variables are set
foreach(target ${LLVM_BUILTIN_TARGETS})
  if(BUILTINS_${target}_CMAKE_TOOLCHAIN_FILE)
    # The toolchain file will define all aspects of the target's build.
    continue()
  endif()

  foreach(variable CMAKE_SYSTEM_NAME CMAKE_SYSTEM_PROCESSOR CMAKE_SYSROOT CMAKE_C_FLAGS)
    if(NOT DEFINED BUILTINS_${target}_${variable})
      message(SEND_ERROR "${target} BUILTINS variable ${variable} is not set")
    endif()
  endforeach()
endforeach()
