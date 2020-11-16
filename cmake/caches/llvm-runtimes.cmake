set(LLVM_BUILTIN_TARGETS
      aarch64-unknown-linux-gnu
      armv7-unknown-linux-gnueabi
      armv7-unknown-linux-gnueabihf
      i386-unknown-linux-gnu
      x86_64-unknown-linux-gnu
      x86_64-unknown-windows-msvc
      aarch64-unknown-fuchsia
      x86_64-unknown-fuchsia
      x86_64-apple-darwin
    CACHE STRING "")

set(LLVM_RUNTIME_TARGETS
      aarch64-unknown-linux-gnu
      armv7-unknown-linux-gnueabi
      armv7-unknown-linux-gnueabihf
      i386-unknown-linux-gnu
      x86_64-unknown-linux-gnu
      x86_64-unknown-windows-msvc
      aarch64-unknown-fuchsia
      x86_64-unknown-fuchsia
      x86_64-apple-darwin
    CACHE STRING "")

set(target x86_64-apple-darwin)
set(RUNTIMES_BUILD_ALLOW_DARWIN ON CACHE STRING "")
set(BUILTINS_${target}_CMAKE_SYSTEM_NAME Darwin CACHE STRING "") # LLVMExternalProjectUtils checks this
set(BUILTINS_${target}_CMAKE_TOOLCHAIN_FILE "${cmake_toolchains}/Toolchain-Darwin-x86_64.cmake" CACHE STRING "")
set(BUILTINS_${target}_XCODE_VERSION ${XCODE_VERSION} CACHE STRING "")
include("${CMAKE_CURRENT_LIST_DIR}/../modules/DarwinSDK.cmake")
set(BUILTINS_${target}_DARWIN_macosx_CACHED_SYSROOT "${macosx_sdk_path}" CACHE STRING "")
set(BUILTINS_${target}_DARWIN_iphoneos_CACHED_SYSROOT "${iphoneos_sdk_path}" CACHE STRING "")
set(BUILTINS_${target}_DARWIN_iphonesimulator_CACHED_SYSROOT "${iphonesimulator_sdk_path}" CACHE STRING "")
set(BUILTINS_${target}_DARWIN_osx_BUILTIN_ARCHS x86_64 x86_64h CACHE STRING "")
set(BUILTINS_${target}_DARWIN_ios_BUILTIN_ARCHS armv7 armv7s arm64 arm64e CACHE STRING "")
set(BUILTINS_${target}_DARWIN_iossim_BUILTIN_ARCHS i386 x86_64 x86_64h CACHE STRING "")

set(RUNTIMES_${target}_CMAKE_SYSTEM_NAME Darwin CACHE STRING "")
set(RUNTIMES_${target}_CMAKE_TOOLCHAIN_FILE "${cmake_toolchains}/Toolchain-Darwin-x86_64.cmake" CACHE STRING "")
set(RUNTIMES_${target}_XCODE_VERSION ${XCODE_VERSION} CACHE STRING "")
set(RUNTIMES_${target}_DARWIN_macosx_CACHED_SYSROOT "${macosx_sdk_path}" CACHE STRING "")
set(RUNTIMES_${target}_DARWIN_iphoneos_CACHED_SYSROOT "${iphoneos_sdk_path}" CACHE STRING "")
set(RUNTIMES_${target}_DARWIN_iphonesimulator_CACHED_SYSROOT "${iphonesimulator_sdk_path}" CACHE STRING "")
set(RUNTIMES_${target}_COMPILER_RT_SANITIZERS_TO_BUILD asan cfi tsan ubsan_minimal CACHE STRING "")
set(RUNTIMES_${target}_DARWIN_osx_ARCHS x86_64 x86_64h CACHE STRING "")
set(RUNTIMES_${target}_DARWIN_ios_ARCHS armv7 armv7s arm64 arm64e CACHE STRING "")
set(RUNTIMES_${target}_DARWIN_iossim_ARCHS i386 x86_64 x86_64h CACHE STRING "")
set(RUNTIMES_${target}_COMPILER_RT_BUILD_LIBFUZZER OFF CACHE BOOL "")
set(RUNTIMES_${target}_LLVM_ENABLE_RUNTIMES "compiler-rt" CACHE STRING "")
# This needs to be at least 10.12 to build TSan. It's also used to disable
# building the i386 slice for macOS on 10.15 and above, but we don't build that
# slice anyway, so that's irrelevant for us.
set(RUNTIMES_${target}_DARWIN_macosx_OVERRIDE_SDK_VERSION "10.12" CACHE STRING "")
# TODO(t48839194) - isystem for xray needs to be added to not break Fuchsia
set(RUNTIMES_${target}_COMPILER_RT_BUILD_XRAY OFF CACHE BOOL "")

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
set(RUNTIMES_${target}_CMAKE_BUILD_WITH_INSTALL_RPATH ON CACHE STRING "")
# TODO(t48839194) - isystem for xray needs to be added to not break Fuchsia
set(RUNTIMES_${target}_COMPILER_RT_BUILD_XRAY OFF CACHE BOOL "")

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
set(RUNTIMES_${target}_CMAKE_BUILD_WITH_INSTALL_RPATH ON CACHE STRING "")

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
set(RUNTIMES_${target}_CMAKE_BUILD_WITH_INSTALL_RPATH ON CACHE STRING "")

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

