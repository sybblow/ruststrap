# armv7a-unknown-linux-gnueabihf configuration
CROSS_PREFIX_armv7a-unknown-linux-gnueabihf=arm-linux-gnueabihf-
CC_armv7a-unknown-linux-gnueabihf=gcc
CXX_armv7a-unknown-linux-gnueabihf=g++
CPP_armv7a-unknown-linux-gnueabihf=gcc -E
AR_armv7a-unknown-linux-gnueabihf=ar
CFG_LIB_NAME_armv7a-unknown-linux-gnueabihf=lib$(1).so
CFG_STATIC_LIB_NAME_armv7a-unknown-linux-gnueabihf=lib$(1).a
CFG_LIB_GLOB_armv7a-unknown-linux-gnueabihf=lib$(1)-*.so
CFG_LIB_DSYM_GLOB_armv7a-unknown-linux-gnueabihf=lib$(1)-*.dylib.dSYM
CFG_JEMALLOC_CFLAGS_armv7a-unknown-linux-gnueabihf := -D__arm__ $(CFLAGS)
CFG_GCCISH_CFLAGS_armv7a-unknown-linux-gnueabihf := -Wall -g -fPIC -D__arm__ $(CFLAGS)
CFG_GCCISH_CXXFLAGS_armv7a-unknown-linux-gnueabihf := -fno-rtti $(CXXFLAGS)
CFG_GCCISH_LINK_FLAGS_armv7a-unknown-linux-gnueabihf := -shared -fPIC -g
CFG_GCCISH_DEF_FLAG_armv7a-unknown-linux-gnueabihf := -Wl,--export-dynamic,--dynamic-list=
CFG_GCCISH_PRE_LIB_FLAGS_armv7a-unknown-linux-gnueabihf := -Wl,-whole-archive
CFG_GCCISH_POST_LIB_FLAGS_armv7a-unknown-linux-gnueabihf := -Wl,-no-whole-archive
CFG_DEF_SUFFIX_armv7a-unknown-linux-gnueabihf := .linux.def
CFG_LLC_FLAGS_armv7a-unknown-linux-gnueabihf :=
CFG_INSTALL_NAME_ar,-unknown-linux-gnueabihf =
CFG_EXE_SUFFIX_armv7a-unknown-linux-gnueabihf :=
CFG_WINDOWSY_armv7a-unknown-linux-gnueabihf :=
CFG_UNIXY_armv7a-unknown-linux-gnueabihf := 1
CFG_PATH_MUNGE_armv7a-unknown-linux-gnueabihf := true
CFG_LDPATH_armv7a-unknown-linux-gnueabihf :=
CFG_RUN_armv7a-unknown-linux-gnueabihf=$(2)
CFG_RUN_TARG_armv7a-unknown-linux-gnueabihf=$(call CFG_RUN_armv7a-unknown-linux-gnueabihf,,$(2))
RUSTC_FLAGS_armv7a-unknown-linux-gnueabihf := -C target-feature=-mcpu=cortex-a8 -fpu=NEON -mfloat-abi=hard
RUSTC_CROSS_FLAGS_armv7a-unknown-linux-gnueabihf :=
CFG_GNU_TRIPLE_armv7a-unknown-linux-gnueabihf := armv7a-unknown-linux-gnueabihf
