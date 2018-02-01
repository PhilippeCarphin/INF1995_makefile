# Variables donnant la structure du projet.
# Pour un projet rapide, on peut mettre toutes ces variables égales à "." et
# tout laisser dans le même dossier.
inc_dir = ./include
src_dir = ./src
build_dir = ./build
exec_dir = ./exec

# Nom qui sera utilisé pour former le nom de certains fichiers
PROJECTNAME=phil_robot

MCU=atmega324pa
CLK_FREQ=8000000

####### Options de compilation #######
CC=avr-gcc
INC= -I $(inc_dir)
OPTLEVEL=s
CFLAGS = -MMD $(INC) -g -mmcu=$(MCU) -O$(OPTLEVEL) -fpack-struct -fshort-enums \
         -funsigned-bitfields -funsigned-char -DF_CPU=$(CLK_FREQ) -Wall
CXXFLAGS=-fno-exceptions

############# Options de linking #############
LIBS=
LDFLAGS=-Wl,-Map,$(exec).map -mmcu=$(MCU)

###### Install related ##############
OBJCOPY=avr-objcopy
AVRDUDE=avrdude
AVRDUDE_PROGRAMMERID=usbasp
HEXFORMAT=ihex

####### Noms de fichiers ##################
exec=$(exec_dir)/$(PROJECTNAME).out
HEXROMTRG=$(exec_dir)/$(PROJECTNAME).hex
HEXTRG=$(HEXROMTRG) $(exec_dir)/$(PROJECTNAME).ee.hex

####### Listes de fichiers #################
SRC_CPP = $(wildcard $(src_dir)/*.cpp)
SRC_C = $(wildcard $(src_dir)/*.c)
SRC = $(SRC_CPP) $(SRC_C)
OBJ= $(subst $(src_dir),$(build_dir),$(SRC_CPP:.cpp=.o) $(SRC_C:.c=.o))

.PHONY: all install clean
all: $(exec)

$(exec): $(OBJ)
	$(CC) $(LDFLAGS) -o $(exec) $(OBJ) -lm $(LIBS)

$(build_dir)/%.o: $(src_dir)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

$(build_dir)/%.o: $(src_dir)/%.cpp
	$(CC) $(CFLAGS) $(CXXFLAGS) -c $< -o $@

$(exec_dir)/%.hex: $(exec_dir)/%.out
	$(OBJCOPY) -j .text -j .data -O $(HEXFORMAT) $< $@

install: $(HEXROMTRG)
	$(AVRDUDE) -c $(AVRDUDE_PROGRAMMERID) -p $(MCU) -P -e -U flash:w:$(HEXROMTRG)

vars:
	@echo "SRC_CPP = $(SRC_CPP)"
	@echo "SRC_C = $(SRC_C)"
	@echo "SRC = $(SRC)"
	@echo "OBJ = $(OBJ)"
	@echo "CFLAGS = $(CFLAGS)"
	@echo "INC = $(INC)"
	@echo "LIBS = $(LIBS)"
	@echo "LDFLAGS = $(LDFLAGS)"

clean:
	$(RM) $(exec) $(exec).map $(OBJ) $(HEXTRG) *.d
