########       AVR Project Makefile       ########
#####                                        #####
#####      Makefile produit et ecrit par     #####
#####   Simon Barrette & Jerome Collin pour  #####
#####           INF1995 - 2016               #####
#####                                        #####
#####         Inspire de Pat Deegan -        #####
#####  Psychogenic Inc (www.psychogenic.com) #####
##################################################
PROJECTNAME=test
PRJSRC=$(wildcard *.cpp)
MCU=atmega324pa

################################# Outils #######################################
CC=avr-gcc
LD=avr-gcc
OBJCOPY=avr-objcopy
AVRDUDE=avrdude

############################### Fichiers #######################################
CFILES=$(filter %.c, $(PRJSRC))
CPPFILES=$(filter %.cpp, $(PRJSRC))
OBJDEPS=$(CFILES:.c=.o) $(CPPFILES:.cpp=.o)

TRG=$(PROJECTNAME).out
HEXROMTRG=$(PROJECTNAME).hex

######################### Variables pour la compilation ########################
INC=-I.
OPTLEVEL=s
WARNING_FLAGS=-Wall
MISC_FLAGS=-fpack-struct -fshort-enums -funsigned-bitfields -funsigned-char
CFLAGS=-MMD $(INC) -g -mmcu=$(MCU) -O$(OPTLEVEL) $(WARNING_FLAGS) $(MISC_FLAGS)
CXXFLAGS=-fno-exceptions

############################# Variables pour le linking ########################
LIBS=
LDFLAGS=-Wl,-Map,$(TRG).map -mmcu=$(MCU)

########################### Settings pour avr-objcopy ##########################
HEXFORMAT=ihex

########################### Settings pour make install #########################
AVRDUDE_PROGRAMMERID=usbasp

.PHONY: all install clean
all: $(TRG)

$(TRG): $(OBJDEPS)
	$(LD) $(LDFLAGS) -o $(TRG) $(OBJDEPS) -lm $(LIBS)

%.o: %.c
	$(CC) $(CFLAGS) -c $<

%.o: %.cpp
	$(CC) $(CFLAGS) $(CXXFLAGS) -c $<

-include *.d

%.hex: %.out
	$(OBJCOPY) -j .text -j .data -O $(HEXFORMAT) $< $@

install: $(HEXROMTRG)
	$(AVRDUDE) -c $(AVRDUDE_PROGRAMMERID) -p $(MCU) -P -e -U flash:w:$(HEXROMTRG)

clean:
	$(RM) $(TRG) $(TRG).map $(OBJDEPS) *.d

#####                    EOF                   #####
