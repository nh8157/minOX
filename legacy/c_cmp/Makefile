SRC=basic.c
OBJ=basic.o
BIN=basic.bin
DISF=basic.dis
CC=x86_64-linux-gnu-gcc -ffreestanding
LD=x86_64-linux-gnu-ld -Ttext 0x0 --oformat binary
DIS=ndisasm -b 32

all:build

$(OBJ): $(SRC)
	$(CC) -c $(SRC) -o $(OBJ)

$(BIN): $(OBJ)
	$(LD) $(OBJ) -o $(BIN) 

build: $(BIN)

disassemble:$(BIN)
	$(DIS) $(BIN) > $(DISF)	
	less $(DISF)	

clean:
	rm -rf *.bin *.o *.dis
