GENIMG = ./genimg
QEMU = qemu-system-x86_64

QEMUFLAGS =	-bios /usr/share/ovmf/OVMF.fd \
			-m 4096                       \
			-no-reboot                    \
			-no-shutdown                  \
			-smp 4

KERNELDIR = kernel
IMAGEDIR = image

KERNELFILE = kernel.elf
IMAGEFILE = os.img

.PHONY: run $(IMAGEFILE) clean

$(IMAGEFILE): $(IMAGEDIR)/$(KERNELFILE)
	@echo Generating Hard Disk Image...
	@$(GENIMG)

run: $(IMAGEFILE)
	@echo Testing image in QEMU...
	@$(QEMU) $(IMAGEFILE) $(QEMUFLAGS)

$(IMAGEDIR)/$(KERNELFILE) : $(KERNELDIR)/$(KERNELFILE)
	@echo Copying kernel...
	@cp $< $@
	
$(KERNELDIR)/$(KERNELFILE): 
	@echo Building kernel...
	@$(MAKE) -C $(KERNELDIR)

clean:
	@$(MAKE) -C $(KERNELDIR) clean
