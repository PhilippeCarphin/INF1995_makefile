########       AVR Project Makefile       ########
#####                                        #####
#####      Makefile produit et ecrit par     #####
#####   Simon Barrette & Jerome Collin pour  #####
#####           INF1995 - 2016               #####
#####                                        #####
#####         Inspire de Pat Deegan -        #####
#####  Psychogenic Inc (www.psychogenic.com) #####
##################################################
src_dir = src
build_dir = build
inc_dir = include

PROJECTNAME=test
PRJSRC=$(wildcard $(src_dir)/*.cpp)
MCU=atmega324pa

################################# Outils #######################################
CC=avr-gcc
LD=avr-gcc
OBJCOPY=avr-objcopy
AVRDUDE=avrdude

############################### Fichiers #######################################
CFILES=$(filter %.c, $(PRJSRC))
CPPFILES=$(filter %.cpp, $(PRJSRC))
OBJDEPS=$(subst $(src_dir),$(build_dir),$(CFILES:.c=.o) $(CPPFILES:.cpp=.o))

TRG=$(build_dir)/$(PROJECTNAME).out
HEXROMTRG=$(build_dir)/$(PROJECTNAME).hex

######################### Variables pour la compilation ########################
INC=-I. -I$(inc_dir)
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

$(build_dir)/%.o: $(src_dir)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

$(build_dir)/%.o: $(src_dir)/%.cpp
	$(CC) $(CFLAGS) $(CXXFLAGS) -c $< -o $@

-include *.d

%.hex: %.out
	$(OBJCOPY) -j .text -j .data -O $(HEXFORMAT) $< $@

install: $(HEXROMTRG)
	$(AVRDUDE) -c $(AVRDUDE_PROGRAMMERID) -p $(MCU) -P -e -U flash:w:$(HEXROMTRG)

clean:
	$(RM) $(TRG) $(TRG).map $(build_dir)/*.o $(build_dir)/*.d

vars:
	@echo "OBJDEPS = $(OBJDEPS)"

#####                    EOF                   #####
