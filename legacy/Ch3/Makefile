MAKE=nasm
BOOTSRC=boot_sec.asm
BOOTBIN=boot_sec.bin
QEMU=qemu-system-x86_64

build:$(BOOTSRC)
	$(MAKE) $(BOOTSRC) -f bin -o $(BOOTBIN)

run:build
	$(QEMU) $(BOOTBIN)

clean:
	rm -rf *.bin
