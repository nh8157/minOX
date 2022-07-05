C_SOURCES=$(wildcard kernel/*.c drivers/*.c)		# Generates a list of mapping to the C files
OBJ=${C_SOURCES:.c=.o}								# Replaces .c file extension with .o

NS=nasm
NS_FLAG_32=-f elf32 -o
NS_FLAG_BIN=-f bin -o
CC=gcc 
CC_FLAG=-m32 -fno-PIC -ffreestanding -c
LN=ld 
LN_FLAG=-no-PIE -m elf_i386 -Ttext 0x1000 --oformat binary
QEMU=qemu-system-x86_64
MERGER=cat

all:os-img

%.o:%.c
	$(CC) $(CC_FLAG) $^	-o $@
	
%.o:%.asm
	$(NS) $< $(NS_FLAG_32) $@

%.bin:%.asm
	$(NS) $< $(NS_FLAG_BIN) $@

kernel.bin:boot/kernel_entry.o ${OBJ}
	$(LN) $(LN_FLAG) $^ -o $@

os-img:boot/boot_sec.bin kernel.bin
	cat $^ > os-img

run:clean os-img
	$(QEMU) os-img 

clean:
	rm -rf *.bin *.o *.dis os-img **/*.bin **/*.o
