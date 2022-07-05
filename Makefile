KERNELSRC=kernel.c
KERNELOBJ=kernel.o
KERNELBIN=kernel.bin
KERENTSRC=kernel_entry.asm
KERENTOBJ=kernel_entry.o
BOOTSRC=boot_sec.asm
BOOTBIN=boot_sec.bin
OSIMG=os-img

NS=nasm
CC=gcc -m32 -fno-PIC -ffreestanding -c
LN=ld -no-PIE -m elf_i386 -Ttext 0x1000 --oformat binary
QEMU=qemu-system-x86_64
MERGER=cat

all:$(OSIMG)

$(KERNELOBJ):$(KERNELSRC)
	$(CC) $^ -o $@ 

$(KERNELBIN):$(KERNELOBJ) 
	$(LN) $^ -o $@

$(KERENTOBJ):$(KERNELSRC)
	$(NS) $(KERENTSRC) -f elf32 -o $(KERENTOBJ)	

$(BOOTBIN):$(BOOTSRC)
	$(NS) $(BOOTSRC) -f bin -o $(BOOTBIN)

$(OSIMG):$(BOOTBIN) $(KERNELBIN)
	$(MERGER) $(BOOTBIN) $(KERNELBIN) > $(OSIMG)

run:clean $(OSIMG)
	$(QEMU) $(OSIMG)

clean:
	rm -rf *.bin *.o *.dis $(OSIMG)
