
function(windows_arch_spelling arch var)
  if(${arch} STREQUAL i686)
    set(${var} x86 PARENT_SCOPE)
  elseif(${arch} STREQUAL x86_64)
    set(${var} x64 PARENT_SCOPE)
  elseif(${arch} STREQUAL armv7)
    set(${var} arm PARENT_SCOPE)
  elseif(${arch} STREQUAL aarch64)
    set(${var} arm64 PARENT_SCOPE)
  else()
    message(FATAL_ERROR "do not know MSVC spelling for ARCH: `${arch}`")
  endif()
endfunction()

function(windows_include_path_for_arch arch var)
  set(${var}
        "${VCToolsInstallDir}/include"
        "${UniversalCRTSdkDir}/Include/${UCRTVersion}/ucrt"
        "${UniversalCRTSdkDir}/Include/${UCRTVersion}/shared"
        "${UniversalCRTSdkDir}/Include/${UCRTVersion}/um"
      PARENT_SCOPE)
endfunction()

function(windows_library_path_for_arch arch var)
  set(paths)

  # NOTE(compnerd) provide compatibility with VS2015 which had the libraries in
  # a directory called "Lib" rather than VS2017 which normalizes the layout and
  # places them in a directory named "lib".
  if(IS_DIRECTORY "${VCToolsInstallDir}/Lib")
    if(${arch} STREQUAL x86)
      list(APPEND paths "${VCToolsInstallDir}/Lib/")
    else()
      list(APPEND paths "${VCToolsInstallDir}/Lib/${arch}")
    endif()
  else()
    list(APPEND paths "${VCToolsInstallDir}/lib/${arch}")
  endif()

  list(APPEND paths
          "${UniversalCRTSdkDir}/Lib/${UCRTVersion}/ucrt/${arch}"
          "${UniversalCRTSdkDir}/Lib/${UCRTVersion}/um/${arch}")

  set(${var} "${paths}" PARENT_SCOPE)
endfunction()

function(windows_compute_compile_flags variable)
  windows_arch_spelling(${CMAKE_SYSTEM_PROCESSOR} arch)
  windows_include_path_for_arch(${arch} paths)

  set(compile_flags "-D_CRT_SECURE_NO_WARNINGS --target=${CMAKE_SYSTEM_PROCESSOR}-unknown-windows-msvc ")
  foreach(path ${paths})
    list(APPEND compile_flags "-imsvc ${path} ")
  endforeach()

  string(REPLACE ";" " " compile_flags ${compile_flags})
  set(${variable} "${compile_flags}" PARENT_SCOPE)
endfunction()

function(windows_compute_link_flags variable)
  windows_arch_spelling(${CMAKE_SYSTEM_PROCESSOR} arch)
  windows_library_path_for_arch(${arch} paths)

  set(link_flags)
  foreach(path ${paths})
    list(APPEND link_flags "-libpath:${path} ")
  endforeach()

  string(REPLACE ";" " " link_flags ${link_flags})
  set(${variable} "${link_flags}" PARENT_SCOPE)
endfunction()

function(windows_create_vfs_overlay flags)
  # TODO(compnerd) use a target to avoid re-creating this file all the time
  configure_file("${TOOLCHAIN_SOURCE_DIR}/infrastructure/WindowsSDKVFSOverlay.yaml.in"
                 "${CMAKE_BINARY_DIR}/windows-sdk-vfs-overlay.yaml"
                 @ONLY)

  set(${flags}
        "-Xclang -ivfsoverlay -Xclang ${CMAKE_BINARY_DIR}/windows-sdk-vfs-overlay.yaml"
      PARENT_SCOPE)
endfunction()

function(windows_create_lib_overlay flags)
  set(overlay ${CMAKE_BINARY_DIR}/WindowsSDKLibraryOverlay)

  execute_process(COMMAND ${CMAKE_COMMAND} -E make_directory ${overlay})

  windows_arch_spelling(${CMAKE_SYSTEM_PROCESSOR} arch)
  set(from ${UniversalCRTSdkDir}/Lib/${UCRTVersion}/um/${arch})
  file(GLOB libraries RELATIVE "${from}" "${from}/*")
  foreach(library ${libraries})
    string(TOLOWER ${library} library_downcase)
    if(NOT library STREQUAL library_downcase)
      execute_process(COMMAND
                        ${CMAKE_COMMAND} -E create_symlink ${from}/${library} ${overlay}/${library_downcase})
    endif()

    get_filename_component(name_we ${library} NAME_WE)
    get_filename_component(ext ${library} EXT)
    string(TOLOWER ${ext} ext_downcase)
    set(library_ext_downcase ${name_we}${ext_downcase})
    if(NOT library STREQUAL library_ext_downcase AND
       NOT library_downcase STREQUAL library_ext_downcase)
      execute_process(COMMAND
                        ${CMAKE_COMMAND} -E create_symlink ${from}/${library} ${overlay}/${library_ext_downcase})
    endif()
  endforeach()

  set(${flags} -libpath:${overlay} PARENT_SCOPE)
endfunction()

