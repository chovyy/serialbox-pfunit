.PHONY: clean all

LIBROOT=/home/christian/lib
PFUNIT=$(LIBROOT)/pfunit
## Serialbox
SERIALBOX=$(LIBROOT)/serialbox
SB_INCLUDE=-I$(SERIALBOX)/include/fortran
SB_LIBS=-L$(SERIALBOX)/lib -lFortranSer -lSerialboxWrapper -lSerialbox -lUtils -ljson -lstdc++ -lsha256
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
INCLUDE=-I$(PFUNIT)/mod -I$(PFUNIT)/include $(SB_INCLUDE)

######################################################

all: $(TEST)
	./$(TEST)

$(TEST): testSuites.inc $(TEST).o 
	$(FF) -o $@ $(FFLAGS) $(INCLUDE) -I$(DIR) $(PFUNIT)/include/driver.F90 $(TEST).o $(LIBS) $(FPPFLAGS)
	
%.o: %.F90
	$(FF) -c $(FFLAGS) $(INCLUDE) $(FPPFLAGS) $<	
	
%.F90: %.pf
	$(PFUNIT)/bin/pFUnitParser.py $<  $@	
	
clean:
	rm -f $(TEST) *.o *.mod *.F90 sbdata/*