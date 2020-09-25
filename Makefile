
ifeq ($(OS),Windows_NT)
  BuildOS := Windows
  ifeq ($(PROCESSOR_ARCHITEW6432),AMD64)
    BuildArch := x86_64
  else ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
    BuildArch := x86_64
  else ifeq ($(PROCESSOR_ARCHITECTURE),X86)
    BuildArch := i686
  else
    $(error "Unknown processor: $(PROCESSOR_ARCHITECTURE)")
  endif
  EXE := .exe
else
  BuildOS := $(shell uname -s)
  BuildArch := $(shell uname -m)
  ifeq ($(BuildArch),amd64)
    BuildArch := x86_64
  endif
endif

Build := $(BuildOS)-$(BuildArch)

#  BuildType | CMake Build Type | Debug | Strip | Asserts
# -----------+------------------+-------+-------+---------
# Debug      | Debug            | -g    | N     | Y
# Release    | RelWithDebInfo   | -g    | Y     | Y

BuildType := Debug

Host := $(Build)
HostOS := $(firstword $(subst -, ,$(Host)))
HostArch := $(lastword $(subst -, ,$(Host)))

ifeq ($(BuildType),Debug)
  CMakeBuildType := Debug
  AssertsEnabled := YES
  AssertsVariant := Asserts
  InstallVariant :=
else ifeq ($(BuildType),Release)
  CMakeBuildType := RelWithDebInfo
  AssertsEnabled := YES
  AssertsVariant := Asserts
  InstallVariant := -stripped
else
  $(error BuildType should be either Debug or Release)
endif

MAKEFILE := $(lastword $(MAKEFILE_LIST))

SourceCache := $(abspath $(dir $(MAKEFILE:%:=)))
BinaryCache := $(dir $(SourceCache))BinaryCache

CMakeCaches := $(SourceCache)/infrastructure/cmake/caches

ifeq ($(OS),Windows_NT)
  CMake := $(shell where cmake)
  Ninja := $(shell where ninja)
else
  CMake := $(shell which cmake)
  Ninja := $(shell which ninja)
endif

CMakeFlags := -G Ninja                                                         \
              -DCMAKE_MAKE_PROGRAM="$(Ninja)"                                  \
              -DCMAKE_BUILD_TYPE=$(CMakeBuildType)                             \
              -DCMAKE_INSTALL_PREFIX= # DESTDIR will set the actual path
CMakeFlags += -DCMAKE_SYSTEM_NAME=$(HostOS) -DCMAKE_SYSTEM_PROCESSOR=$(HostArch)

Vendor := unknown
Version := development
XCToolchain = $(Vendor)-$(AssertsVariant)-$(Version).xctoolchain

DESTDIR := $(or $(DESTDIR),$(BinaryCache)/Library/Developer/Toolchains/$(XCToolchain)/usr)

# --- toolchain-tools ---
$(BinaryCache)/Release/$(Build)/toolchain-tools/build.ninja:
	"$(CMake)"                                                             \
	  -B $(BinaryCache)/Release/$(Build)/toolchain-tools                   \
	  -D CMAKE_BUILD_TYPE=Release                                          \
	  -D CMAKE_MAKE_PROGRAM="$(Ninja)"                                     \
	  -D LLVM_ENABLE_ASSERTIONS=NO                                         \
	  -D LLVM_ENABLE_PROJECTS="clang;lldb"                                 \
	  -G Ninja                                                             \
	  -S $(SourceCache)/llvm-project/llvm

$(BinaryCache)/Release/$(Build)/toolchain-tools/bin/clang-tblgen$(EXE): $(BinaryCache)/Release/$(Build)/toolchain-tools/build.ninja
$(BinaryCache)/Release/$(Build)/toolchain-tools/bin/clang-tblgen$(EXE):
	"$(Ninja)" -C $(BinaryCache)/Release/$(Build)/toolchain-tools clang-tblgen

$(BinaryCache)/Release/$(Build)/toolchain-tools/bin/lldb-tblgen$(EXE): $(BinaryCache)/Release/$(Build)/toolchain-tools/build.ninja
$(BinaryCache)/Release/$(Build)/toolchain-tools/bin/lldb-tblgen$(EXE):
	"$(Ninja)" -C $(BinaryCache)/Release/$(Build)/toolchain-tools lldb-tblgen

$(BinaryCache)/Release/$(Build)/toolchain-tools/bin/llvm-tblgen$(EXE): $(BinaryCache)/Release/$(Build)/toolchain-tools/build.ninja
$(BinaryCache)/Release/$(Build)/toolchain-tools/bin/llvm-tblgen$(EXE):
	"$(Ninja)" -C $(BinaryCache)/Release/$(Build)/toolchain-tools llvm-tblgen

# --- toolchain ---
$(BinaryCache)/$(BuildType)/$(Host)/toolchain/build.ninja: $(BinaryCache)/Release/$(Build)/toolchain-tools/bin/clang-tblgen$(EXE)
$(BinaryCache)/$(BuildType)/$(Host)/toolchain/build.ninja: $(BinaryCache)/Release/$(Build)/toolchain-tools/bin/lldb-tblgen$(EXE)
$(BinaryCache)/$(BuildType)/$(Host)/toolchain/build.ninja: $(BinaryCache)/Release/$(Build)/toolchain-tools/bin/llvm-tblgen$(EXE)
$(BinaryCache)/$(BuildType)/$(Host)/toolchain/build.ninja:
	"$(CMake)" $(CMakeFlags)                                               \
	  -B $(BinaryCache)/$(BuildType)/$(Host)/toolchain                     \
	  -C $(CMakeCaches)/toolchain-$(Host).cmake                            \
	  -C $(CMakeCaches)/toolchain-common.cmake                             \
	  -C $(CMakeCaches)/toolchain.cmake                                    \
	  -D LLVM_ENABLE_ASSERTIONS=$(AssertsEnabled)                          \
	  -D LLVM_USE_HOST_TOOLS=NO                                            \
	  -D CLANG_TABLEGEN=$(BinaryCache)/Release/$(Build)/toolchain-tools/bin/clang-tblgen$(EXE) \
	  -D LLDB_TABLEGEN=$(BinaryCache)/Release/$(Build)/toolchain-tools/bin/lldb-tblgen$(EXE) \
	  -D LLVM_TABLEGEN=$(BinaryCache)/Release/$(Build)/toolchain-tools/bin/llvm-tblgen$(EXE) \
	  -D SWIFT_PATH_TO_LIBDISPATCH_SOURCE=$(SourceCache)/swift-corelibs-libdispatch \
	  -S $(SourceCache)/llvm-project/llvm

.PHONY: toolchain
toolchain: $(BinaryCache)/$(BuildType)/$(Host)/toolchain/build.ninja
toolchain:
	"$(CMake)" -E env DESTDIR=$(DESTDIR) "$(Ninja)" -C $(BinaryCache)/$(BuildType)/$(Host)/toolchain install-distribution$(InstallVariant)

# --- swift-stdlib ---
$(BinaryCache)/$(BuildType)/$(Host)/swift-stdlib/build.ninja:
	"$(CMake)" $(CMakeFlags)                                               \
	  -B $(BinaryCache)/$(BuildType)/$(Host)/swift-stdlib                  \
	  -C $(CMakeCaches)/swift-stdlib-$(Host).cmake                         \
	  -C $(CMakeCaches)/swift-stdlib-common.cmake                          \
	  -S $(SourceCache)/llvm-project/swift

.PHONY: swift-stdlib
swift-stdlib: $(BinaryCache)/$(BuildType)/$(Host)/swift-stdlib/build.ninja
swift-stdlib:
	"$(CMake)" -E env DESTDIR=$(DESTDIR) "$(Ninja)" -C $(BinaryCache)/$(BuildType)/$(Host)/swift-stdlib install

# --- libdispatch ---
$(BinaryCache)/$(BuildType)/$(Host)/swift-corelibs-libdispatch/build.ninja: $(BinaryCache)/$(BuildType)/$(Host)/swift-stdlib/build.ninja
$(BinaryCache)/$(BuildType)/$(Host)/swift-corelibs-libdispatch/build.ninja:
	"$(CMake)" $(CMakeFlags)                                               \
	  -B $(BinaryCache)/$(BuildType)/$(Host)/swift-corelibs-libdispatch    \
	  -C $(CMakeCaches)/swift-corelibs-libdispatch-$(Host).cmake           \
	  -D Swift_DIR=$(BinaryCache)/$(BuildType)/$(Host)/swift-stdlib/lib/cmake/swift \
	  -S $(SourceCache)/swift-corelibs-libdispatch

.PHONY: swift-corelibs-libdispatch
swift-corelibs-libdispatch: $(BinaryCache)/swift-corelibs-libdispatch/build.ninja
swift-corelibs-libdispatch:
	"$(CMake)" -E env DESTDIR=$(DESTDIR) "$(Ninja)" -C $(BinaryCache)/$(BuildType)/$(Host)/swift-corelibs-libdispatch install

# --- foundation ---
$(BinaryCache)/$(BuildType)/$(Host)/swift-corelibs-foundation/build.ninja: swift-corelibs-libdispatch
$(BinaryCache)/$(BuildType)/$(Host)/swift-corelibs-foundation/build.ninja:
	"$(CMake)" $(CMakeFlags)                                               \
	  -B $(BinaryCache)/swift-corelibs-foundation                          \
	  -C $(CMakeCaches)/swift-corelibs-foundation-$(Host).cmake            \
	  -D dispatch_DIR=$(BinaryCache)/$(BuildType)/$(Host)/swift-corelibs-libdispatch/cmake/modules \
	  -S $(SourceCache)/swift-corelibs-foundation

.PHONY: swift-corelibs-foundation
swift-corelibs-foundation: $(BinaryCache)/$(BuildType)/$(Host)/swift-corelibs-foundation/build.ninja
swift-corelibs-foundation:
	"$(CMake)" -E env DESTDIR=$(DESTDIR) "$(Ninja)" -C $(BinaryCache)/$(BuildType)/$(Host)/swift-corelibs-foundation install

# --- default ---
.DEFAULT_GOAL := default
default:
