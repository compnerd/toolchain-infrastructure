
get_filename_component(TOOLCHAIN_SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR} REALPATH)
get_filename_component(TOOLCHAIN_SOURCE_DIR ${TOOLCHAIN_SOURCE_DIR} DIRECTORY)
get_filename_component(TOOLCHAIN_SOURCE_DIR ${TOOLCHAIN_SOURCE_DIR} DIRECTORY)
get_filename_component(TOOLCHAIN_SOURCE_DIR ${TOOLCHAIN_SOURCE_DIR} DIRECTORY)
get_filename_component(TOOLCHAIN_SOURCE_DIR ${TOOLCHAIN_SOURCE_DIR} DIRECTORY CACHE)

list(APPEND CMAKE_MODULE_PATH
     ${TOOLCHAIN_SOURCE_DIR}/infrastructure/cmake/modules)

set(toolchain
    ${TOOLCHAIN_SOURCE_DIR}/build/Release/${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}/Developer/Toolchains/unknown-Asserts-bootstrap.xctoolchain)

if(CMAKE_SYSTEM_NAME MATCHES Windows)
  set(CMAKE_C_COMPILER ${toolchain}/usr/bin/clang-cl CACHE FILEPATH "")
  set(CMAKE_CXX_COMPILER ${toolchain}/usr/bin/clang-cl CACHE FILEPATH "")
  set(CMAKE_LINKER ${toolchain}/usr/bin/lld-link CACHE FILEPATH "")
else()
  set(CMAKE_C_COMPILER ${toolchain}/usr/bin/clang CACHE FILEPATH "")
  set(CMAKE_CXX_COMPILER ${toolchain}/usr/bin/clang++ CACHE FILEPATH "")
  set(CMAKE_LINKER ${toolchain}/usr/bin/ld.lld CACHE FILEPATH "")
endif()

set(CMAKE_SWIFT_COMPILER ${toolchain}/usr/bin/swiftc CACHE FILEPATH "")

set(CMAKE_AR ${toolchain}/usr/bin/llvm-ar CACHE FILEPATH "")
set(CMAKE_RANLIB ${toolchain}/usr/bin/llvm-ranlib CACHE FILEPATH "")

if(CMAKE_SYSTEM_NAME STREQUAL Windows)
  if(NOT $ENV{VCToolsInstallDir})
    set(ENV{VCToolsInstallDir} ${TOOLCHAIN_SOURCE_DIR}/WinSDK/MSVC/14.15.26726)
  endif()
  if(NOT $ENV{UniversalCRTSdkDir})
    set(ENV{UniversalCRTSdkDir} ${TOOLCHAIN_SOURCE_DIR}/WinSDK/SDK)
  endif()
  if(NOT $ENV{UCRTVersion})
    set(ENV{UCRTVersion} 10.0.17134.0)
  endif()

  include(WindowsSDK)

  foreach(v CMAKE_C_FLAGS CMAKE_CXX_FLAGS CMAKE_EXE_LINKER_FLAGS
            CMAKE_SHARED_LINKER_FLAGS CMAKE_STATIC_LINKER_FLAGS)
    set(_${v}_INITIAL "${${v}}" CACHE STRING "")
  endforeach()

  windows_compute_compile_flags(flags)
  windows_create_vfs_overlay(overlay_flags)
  set(CMAKE_C_FLAGS "${_CMAKE_C_FLAGS_INITIAL} ${flags} ${overlay_flags}" CACHE STRING "" FORCE)
  set(CMAKE_CXX_FLAGS "${_CMAKE_CXX_FLAGS_INITIAL} ${flags} ${overlay_flags}" CACHE STRING "" FORCE)

  windows_compute_link_flags(flags)
  windows_create_lib_overlay(overlay_flags)
  set(CMAKE_EXE_LINKER_FLAGS "${_CMAKE_EXE_LINKER_FLAGS_INITIAL} -fuse-ld=lld /MANIFEST:NO ${flags} ${overlay_flags}" CACHE STRING "" FORCE)
  set(CMAKE_SHARED_LINKER_FLAGS "${_CMAKE_SHARED_LINKER_FLAGS_INITIAL} -fuse-ld=lld /MANIFEST:NO ${flags} ${overlay_flags}" CACHE STRING "" FORCE)
  set(CMAKE_STATIC_LINKER_FLAGS "${_CMAKE_STATIC_LINKER_FLAGS_INITIAL} ${flags} ${overlay_flags}" CACHE STRING "" FORCE)

  # CMake populates these with a bunch of unnecessary libraries.  Ensure that
  # projects explicitly control which libraries they require.
  set(CMAKE_C_STANDARD_LIBRARIES "" CACHE STRING "" FORCE)
  set(CMAKE_CXX_STANDARD_LIBRARIES "" CACHE STRING "" FORCE)

  set(CMAKE_USER_MAKE_RULES_OVERRIDE "${TOOLCHAIN_SOURCE_DIR}/infrastructure/cmake/modules/WindowsCompileRules.cmake")
endif()

if(NOT CMAKE_SYSTEM_NAME STREQUAL CMAKE_HOST_SYSTEM_NAME)
  set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
  set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
  set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
  set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
endif()

