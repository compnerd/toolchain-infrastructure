
include(${BUILD_DIR}/lib/cmake/llvm/LLVMConfigVersion.cmake)

# NOTE(compnerd) message(STATUS ...) prints a `-- ` before the message, and
# message() writes to stderr instead of stdout, so just echo manually
execute_process(COMMAND ${CMAKE_COMMAND} -E echo ${PACKAGE_VERSION})
