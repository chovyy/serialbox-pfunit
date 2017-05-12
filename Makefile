.PHONY: clean all

LIBROOT=/home/christian/lib
PFUNIT=$(LIBROOT)/pfunit
## Serialbox
SERIALBOX=$(LIBROOT)/serialbox
SB_INCLUDE=-I$(SERIALBOX)/include/fortran
SB_LIBS=-L$(SERIALBOX)/lib -lFortranSer -lSerialBoxWrapper -lSerialBox -lUtils -ljson -lstdc++ -lsha256
## Serialbox2
#SERIALBOX=$(LIBROOT)/serialbox2
#SB_INCLUDE=-I$(SERIALBOX)/include
#SB_LIBS=-L$(SERIALBOX)/lib -lSerialboxCore -lSerialboxC -lSerialboxFortran -lstdc++

DIR=$(shell pwd)
TEST=serialbox_test

FF=gfortran
FFLAGS = -g -O0 -fbacktrace -fbounds-check -fcheck=mem
FPPFLAGS = -DGNU -DBUILD_ROBUST
LIBS = -L$(PFUNIT)/lib -lpfunit $(SB_LIBS)
INCLUDE=-I$(PFUNIT)/mod -I$(PFUNIT)/include -I$(DIR) $(SB_INCLUDE)

######################################################

all: $(TEST)
	./$(TEST)

$(TEST): testSuites.inc $(TEST).o 
	$(FF) -o $@ $(FFLAGS) $(FPPFLAGS) $(INCLUDE) $(PFUNIT)/include/driver.F90 $(TEST).o $(LIBS)
	
$(TEST).o: $(TEST).f90
	$(FF) -c $(FFLAGS) $(FPPFLAGS) $(INCLUDE) $<	
	
$(TEST).f90: $(TEST).pf
	$(PFUNIT)/bin/pFUnitParser.py $<  $@	
	
clean:
	rm -f $(TEST) *.o *.mod *.f90 sbdata/*