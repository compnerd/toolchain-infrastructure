need := 3.82
ifneq ($(need), $(firstword $(sort $(MAKE_VERSION) $(need))))
  $(error You need at least make version >= $(need))
endif

BuildOS := $(shell uname -s)
BuildArch := $(shell uname -m)
ifeq ($(BuildArch),amd64)
  BuildArch := x86_64
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

SourceCache := $(abspath $(dir $(realpath $(lastword $(MAKEFILE_LIST))))..)
BinaryCache := $(dir $(SourceCache))BinaryCache

CMakeCaches := $(SourceCache)/infrastructure/cmake/caches
CMakeScripts := $(SourceCache)/infrastructure/cmake/scripts

CMake := $(shell which cmake)
Ninja := $(shell which ninja)

CMakeFlags := -G Ninja                                                         \
              -DCMAKE_MAKE_PROGRAM=$(Ninja)                                    \
              -DCMAKE_BUILD_TYPE=$(CMakeBuildType)                             \
              -DCMAKE_INSTALL_PREFIX= # DESTDIR will set the actual path

# inform the build where the source tree resides
CMakeFlags += -DTOOLCHAIN_SOURCE_DIR=$(SourceCache)
# CMakeFlags += -DCMAKE_SYSTEM_NAME=$(HostOS) -DCMAKE_SYSTEM_PROCESSOR=$(HostArch)

Vendor := unknown
Version := Default

XCToolchain = $(Vendor)-$(AssertsVariant)-$(Version).xctoolchain
SwiftStandardLibraryTarget := swift-stdlib-$(shell echo $(HostOS) | tr '[A-Z]' '[a-z]')

DESTDIR := $(or $(DESTDIR),$(BinaryCache)/Library/Developer/Toolchains/$(XCToolchain)/usr)

# --- toolchain-tools ---
$(BinaryCache)/Release/$(Build)/toolchain-tools/build.ninja:
	$(CMake)                                                               \
	  -G Ninja                                                             \
	  -B $(BinaryCache)/Release/$(Build)/toolchain-tools                   \
	  -D CMAKE_BUILD_TYPE=Release                                          \
	  -D CMAKE_MAKE_PROGRAM=$(Ninja)                                       \
	  -D LLDB_DISABLE_PYTHON=YES                                           \
	  -D LLVM_USE_HOST_TOOLS=NO                                            \
	  -D LLVM_ENABLE_ASSERTIONS=NO                                         \
	  -D LLVM_ENABLE_PROJECTS="clang;lldb"                                 \
	  -S $(SourceCache)/llvm-project/llvm

$(BinaryCache)/Release/$(Build)/toolchain-tools/bin/llvm-tblgen: $(BinaryCache)/Release/$(Build)/toolchain-tools/build.ninja
$(BinaryCache)/Release/$(Build)/toolchain-tools/bin/llvm-tblgen:
	$(Ninja) -C $(BinaryCache)/Release/$(Build)/toolchain-tools llvm-tblgen

$(BinaryCache)/Release/$(Build)/toolchain-tools/bin/clang-tblgen: $(BinaryCache)/Release/$(Build)/toolchain-tools/build.ninja
$(BinaryCache)/Release/$(Build)/toolchain-tools/bin/clang-tblgen:
	$(Ninja) -C $(BinaryCache)/Release/$(Build)/toolchain-tools clang-tblgen

$(BinaryCache)/Release/$(Build)/toolchain-tools/bin/lldb-tblgen: $(BinaryCache)/Release/$(Build)/toolchain-tools/build.ninja
$(BinaryCache)/Release/$(Build)/toolchain-tools/bin/lldb-tblgen:
	$(Ninja) -C $(BinaryCache)/Release/$(Build)/toolchain-tools lldb-tblgen

# --- toolchain ---
.PHONY: toolchain
toolchain: $(BinaryCache)/$(BuildType)/$(Host)/toolchain/build.ninja
toolchain:
	DESTDIR=$(DESTDIR) $(Ninja) -C $(BinaryCache)/$(BuildType)/$(Host)/toolchain install-distribution$(InstallVariant)

$(BinaryCache)/$(BuildType)/$(Host)/toolchain/build.ninja: $(BinaryCache)/Release/$(Build)/toolchain-tools/bin/llvm-tblgen
$(BinaryCache)/$(BuildType)/$(Host)/toolchain/build.ninja: $(BinaryCache)/Release/$(Build)/toolchain-tools/bin/clang-tblgen
$(BinaryCache)/$(BuildType)/$(Host)/toolchain/build.ninja: $(BinaryCache)/Release/$(Build)/toolchain-tools/bin/lldb-tblgen
$(BinaryCache)/$(BuildType)/$(Host)/toolchain/build.ninja:
	$(CMake) $(CMakeFlags)                                                 \
	  -B $(BinaryCache)/$(BuildType)/$(Host)/toolchain                     \
	  -C $(CMakeCaches)/toolchain-common.cmake                             \
	  -C $(CMakeCaches)/toolchain.cmake                                    \
	  -C $(CMakeCaches)/toolchain-$(Host).cmake                            \
	  -D LLVM_ENABLE_ASSERTIONS=$(AssertsEnabled)                          \
	  -D LLVM_USE_HOST_TOOLS=NO                                            \
	  -D LLVM_TABLEGEN=$(BinaryCache)/Release/$(Build)/toolchain-tools/bin/llvm-tblgen \
	  -D CLANG_TABLEGEN=$(BinaryCache)/Release/$(Build)/toolchain-tools/bin/clang-tblgen \
	  -D LLDB_TABLEGEN=$(BinaryCache)/Release/$(Build)/toolchain-tools/bin/lldb-tblgen \
	  -D SWIFT_PATH_TO_LIBDISPATCH_SOURCE=$(SourceCache)/swift-corelibs-libdispatch \
	  -S $(SourceCache)/llvm-project/llvm

# --- swift-stdlib ---
define build-swift-stdlib
$$(BinaryCache)/Release/$(1)/llvm/build.ninja:
	$$(CMake) $$(CMakeFlags)                                               \
	  -B $$(BinaryCache)/Release/$(1)/llvm                                 \
	  -D CMAKE_BUILD_TYPE=Release                                          \
	  -G Ninja                                                             \
	  -S $$(SourceCache)/llvm-project/llvm

swift-stdlib-$(1): $$(BinaryCache)/$$(BuildType)/swift-stdlib-$(1)/build.ninja
swift-stdlib-$(1):
	DESTDIR=$(DESTDIR) $(Ninja) -C $$(BinaryCache)/$$(BuildType)/swift-stdlib-$(1) install

$$(BinaryCache)/$$(BuildType)/swift-stdlib-$(1)/build.ninja: $$(BinaryCache)/Release/$(1)/llvm/build.ninja
$$(BinaryCache)/$$(BuildType)/swift-stdlib-$(1)/build.ninja:
	$$(CMake) $$(CMakeFlags)                                               \
	  -B $$(BinaryCache)/$$(BuildType)/swift-stdlib-$(1)                   \
	  -C $$(CMakeCaches)/swift-stdlib-common.cmake                         \
	  -C $$(CMakeCaches)/swift-stdlib-$(1).cmake                           \
	  -D LLVM_DIR=$$(BinaryCache)/Release/$(1)/llvm/lib/cmake/llvm         \
	  -D SWIFT_NATIVE_SWIFT_TOOLS_PATH=$(BinaryCache)/Release/$(Build)/toolchain/bin \
	  -S $$(SourceCache)/llvm-project/swift
endef

swift-stdlib-targets := linux windows android
$(foreach target,$(swift-stdlib-targets),$(eval $(call build-swift-stdlib,$(target))))

# --- libdispatch ---
.PHONY: swift-corelibs-libdispatch
swift-corelibs-libdispatch: $(BuildDir)/swift-corelibs-libdispatch/build.ninja
	DESTDIR=$(DESTDIR) $(Ninja) -C $(BuildDir)/swift-corelibs-libdispatch install

.ONESHELL: $(BuildDir)/swift-corelibs-libdispatch/build.ninja
$(BuildDir)/swift-corelibs-libdispatch/build.ninja: bootstrap-toolchain bootstrap-target-swift
$(BuildDir)/swift-corelibs-libdispatch/build.ninja:
	mkdir -p $(BuildDir)/swift-corelibs-libdispatch
	cd $(BuildDir)/swift-corelibs-libdispatch
	$(CMake) $(CMakeFlags)                                                 \
	  -C $(CMakeCaches)/swift-corelibs-libdispatch-$(Host).cmake           \
	  -DSwift_DIR=$(SourceDir)/build/$(BuildType)/$(SwiftStandardLibraryTarget)/lib/cmake/swift \
	$(SourceDir)/swift-corelibs-libdispatch

# --- foundation ---
.PHONY: swift-corelibs-foundation
swift-corelibs-foundation: bootstrap-target-swift
swift-corelibs-foundation: $(BuildDir)/swift-corelibs-foundation/build.ninja
swift-corelibs-foundation:
	DESTDIR=$(DESTDIR) $(Ninja) -C $(BuildDir)/swift-corelibs-foundation install

.ONESHELL: $(BuildDir)/swift-corelibs-foundation/build.ninja
$(BuildDir)/swift-corelibs-foundation/build.ninja: bootstrap-toolchain
$(BuildDir)/swift-corelibs-foundation/build.ninja: swift-corelibs-libdispatch
$(BuildDir)/swift-corelibs-foundation/build.ninja:
	mkdir -p $(BuildDir)/swift-corelibs-foundation
	cd $(BuildDir)/swift-corelibs-foundation
	$(CMake) $(CMakeFlags)                                                 \
	  -C $(CMakeCaches)/swift-corelibs-foundation-$(Host).cmake            \
	-DFOUNDATION_PATH_TO_LIBDISPATCH_SOURCE=$(SourceDir)/swift-corelibs-libdispatch \
	-DFOUNDATION_PATH_TO_LIBDISPATCH_BUILD=$(BuildDir)/swift-corelibs-libdispatch \
	$(SourceDir)/swift-corelibs-foundation

# --- default ---
.DEFAULT_GOAL := default
default:

# --- distclean ---
distclean:
	rm -rf $(BuildDir)

