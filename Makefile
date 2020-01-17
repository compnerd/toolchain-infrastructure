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

SourceDir := $(abspath $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/..)
BuildDir := $(SourceDir)/build/$(BuildType)/$(Host)

CMakeCaches := $(SourceDir)/infrastructure/cmake/caches
CMakeScripts := $(SourceDir)/infrastructure/cmake/scripts

CMake := $(shell which cmake)
Ninja := $(shell which ninja)

CMakeFlags := -G Ninja                                                         \
              -DCMAKE_MAKE_PROGRAM=$(Ninja)                                    \
              -DCMAKE_BUILD_TYPE=$(CMakeBuildType)                             \
              -DCMAKE_INSTALL_PREFIX= # DESTDIR will set the actual path

# inform the build where the source tree resides
CMakeFlags += -DTOOLCHAIN_SOURCE_DIR=$(SourceDir)
# CMakeFlags += -DCMAKE_SYSTEM_NAME=$(HostOS) -DCMAKE_SYSTEM_PROCESSOR=$(HostArch)

Vendor := unknown
Version := Default

XCToolchain = $(Vendor)-$(AssertsVariant)-$(Version).xctoolchain
SwiftStandardLibraryTarget := swift-stdlib-$(shell echo $(HostOS) | tr '[A-Z]' '[a-z]')

DESTDIR := $(or $(DESTDIR),$(SourceDir)/prebuilt/$(Host)/Developer/Toolchains/$(XCToolchain)/usr)

# --- toolchain-tools ---
$(BuildDir)/toolchain-tools/build.ninja:
	$(CMake)                                                               \
	  -G Ninja                                                             \
	  -B $(BuildDir)/toolchain-tools                                       \
	  -D CMAKE_BUILD_TYPE=Release                                          \
	  -D CMAKE_MAKE_PROGRAM=$(Ninja)                                       \
	  -D LLDB_DISABLE_PYTHON=YES                                           \
	  -D LLVM_USE_HOST_TOOLS=NO                                            \
	  -D LLVM_ENABLE_ASSERTIONS=NO                                         \
	  -D LLVM_ENABLE_PROJECTS="clang;lldb"                                 \
	  -S $(SourceDir)/llvm-project/llvm

$(BuildDir)/toolchain-tools/bin/llvm-tblgen: $(BuildDir)/toolchain-tools/build.ninja
$(BuildDir)/toolchain-tools/bin/llvm-tblgen:
	$(Ninja) -C $(BuildDir)/toolchain-tools llvm-tblgen

$(BuildDir)/toolchain-tools/bin/clang-tblgen: $(BuildDir)/toolchain-tools/build.ninja
$(BuildDir)/toolchain-tools/bin/clang-tblgen:
	$(Ninja) -C $(BuildDir)/toolchain-tools clang-tblgen

$(BuildDir)/toolchain-tools/bin/lldb-tblgen: $(BuildDir)/toolchain-tools/build.ninja
$(BuildDir)/toolchain-tools/bin/lldb-tblgen:
	$(Ninja) -C $(BuildDir)/toolchain-tools lldb-tblgen

# --- toolchain ---
.PHONY: toolchain
toolchain: $(BuildDir)/toolchain/build.ninja
toolchain:
	DESTDIR=$(DESTDIR) $(Ninja) -C $(BuildDir)/toolchain install-distribution$(InstallVariant)

$(BuildDir)/toolchain/build.ninja: $(BuildDir)/toolchain-tools/bin/llvm-tblgen
$(BuildDir)/toolchain/build.ninja: $(BuildDir)/toolchain-tools/bin/clang-tblgen
$(BuildDir)/toolchain/build.ninja: $(BuildDir)/toolchain-tools/bin/lldb-tblgen
$(BuildDir)/toolchain/build.ninja:
	$(CMake) $(CMakeFlags)                                                 \
	  -B $(BuildDir)/toolchain                                             \
	  -C $(CMakeCaches)/toolchain-common.cmake                             \
	  -C $(CMakeCaches)/toolchain.cmake                                    \
	  -C $(CMakeCaches)/toolchain-$(Host).cmake                            \
	  -D LLVM_ENABLE_ASSERTIONS=$(AssertsEnabled)                          \
	  -D LLVM_USE_HOST_TOOLS=NO                                            \
	  -D LLVM_TABLEGEN=$(BuildDir)/toolchain-tools/bin/llvm-tblgen         \
	  -D CLANG_TABLEGEN=$(BuildDir)/toolchain-tools/bin/clang-tblgen       \
	  -D LLDB_TABLEGEN=$(BuildDir)/toolchain-tools/bin/lldb-tblgen         \
	  -D SWIFT_PATH_TO_LIBDISPATCH_SOURCE=$(SourceDir)/swift-corelibs-libdispatch \
	  -S $(SourceDir)/llvm-project/llvm

# --- swift-stdlib ---
define build-swift-stdlib
# swift-stdlib-$(1): bootstrap-toolchain
swift-stdlib-$(1): $$(SourceDir)/build/$$(BuildType)/swift-stdlib-$(1)/build.ninja
swift-stdlib-$(1):
	DESTDIR=$(DESTDIR) $(Ninja) -C $$(SourceDir)/build/$$(BuildType)/swift-stdlib-$(1) install

.ONESHELL: $$(SourceDir)/build/$$(BuildType)/swift-stdlib-$(1)/build.ninja
$$(SourceDir)/build/$$(BuildType)/swift-stdlib-$(1)/build.ninja:
	mkdir -p $$(SourceDir)/build/$$(BuildType)/swift-stdlib-$(1)
	cd $$(SourceDir)/build/$$(BuildType)/swift-stdlib-$(1)
	$$(CMake) $$(CMakeFlags)                                               \
	  -C $$(CMakeCaches)/swift-stdlib-common.cmake                         \
	  -C $$(CMakeCaches)/swift-stdlib-$(1).cmake                           \
	$$(SourceDir)/swift
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

