LIBROOT=/home/christian/lib
PFUNIT=$(LIBROOT)/pfunit
## Serialbox
#SERIALBOX=$(LIBROOT)/serialbox
#SB_INCLUDE=-I$(SERIALBOX)/include/fortran
#SB_LIBS=-L$(SERIALBOX)/lib -lFortranSer -lSerialBoxWrapper -lSerialBox -lUtils -ljson -lstdc++ -lsha256
## Serialbox2
SERIALBOX=$(LIBROOT)/serialbox2
SB_INCLUDE=-I$(SERIALBOX)/include
SB_LIBS=-L$(SERIALBOX)/lib -lSerialboxCore -lSerialboxC -lSerialboxFortran -lstdc++


.PHONY: tests clean all
.DEFAULT_GOAL = tests

# Determine operating system, architecture and compiler
# automatically if possible
UNAME ?=$(shell uname)
ifeq ($(UNAME),)
	UNAME =UNKNOWN
else
# Check for Windows/CYGWIN compilation.
ifneq (,$(findstring CYGWIN,$(UNAME)))
	UNAME =Windows
endif
endif

ifneq ($(UNAME),Windows)
	TOP_DIR := $(shell pwd)
	SRC_DIR=$(TOP_DIR)/src
	TEST_DIR=$(TOP_DIR)/tests
else
	# When using CYGWIN, then relative paths have to be used.
	PFUNIT := ../../../pfunit
	TOP_DIR := $(shell pwd)
	SRC_DIR=src
	TEST_DIR=tests
endif

VPATH = . $(TEST_DIR)

include $(PFUNIT)/include/base.mk

ifeq ($(UNAME),Windows)
	FFLAGS += -DWindows
	ifeq ($(FC),ifort)
		FFLAGS += /nologo
	endif
endif

# The following may be redundant since FC should already be
# appropriately set in include/base.mk.
ifeq ($(USEMPI),YES)
   FC=mpif90
endif

EXE = tests$(EXE_EXT)
ifneq ($(UNAME),Windows)
	LIBS = -L$(PFUNIT)/lib -lpfunit $(SB_LIBS)
else
	LIBS = $(PFUNIT)/lib/libpfunit$(LIB_EXT) $(SB_LIBS)
endif

all: $(EXE)

# ifeq ($(USEMPI),YES)
# 	mpirun -np 1 ./$(EXE)
# else
# 	./$(EXE)
# endif

ifeq ($(USEMPI),YES)
	mpirun -np 1 ./$(EXE) -xml tests.xml
else
	./$(EXE) -xml tests.xml
endif

SUT:
	make -C $(TEST_DIR) tests

tests: all

$(EXE): testSuites.inc SUT
	$(FC) -o $@ -I$(PFUNIT)/mod -I$(PFUNIT)/include -Itests $(PFUNIT)/include/driver.F90 $(TEST_DIR)/*$(OBJ_EXT) $(LIBS) $(FFLAGS) $(FPPFLAGS)

distclean: clean

clean: local-E0-clean

local-E0-clean:
	make -C $(TEST_DIR) clean
	rm -f $(EXE) *$(OBJ_EXT) tests.xml

ifeq ($(UNAME),Windows)
	export PFUNIT
endif

export FC
export FPPFLAGS
export FFLAGS
export TEST_DIR
export OBJ_EXT
export LIB_EXT
export EXE_EXT
export SB_INCLUDE
