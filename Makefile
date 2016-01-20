name := flintOS
arch ?= x86_64
target ?= $(arch)-unknown-linux-gnu
kernel := build/kernel-$(arch).bin
iso := build/$(name)-$(arch).iso

rust-os := target/$(target)/debug/libblog_os.a
linker_scr := src/arch/$(arch)/grub.cfg
assembly_source_files := $(wildcard src/arch/$(arch)/*.asm)
assembly_object_files := $(patsubst src/arch/$(arch)/%.asm, \
	build/arch/$(arch)/%.o, $(assembly_source_files))

.PHONY: all clean run iso cargo

all: $(kernel)

$(kernel): cargo $(linker_scr) $(assembly_object_files) $(rust_os)
	@ld -n --gc-sections -T $(linker_scr) -o $(kernel) $(assembly_object_files) $(rust_os)

cargo:
	@cargo rustc --target $(target) -- -Z no-landing-pads

clean:
	@cargo clean
	@rm -rf build

run: $(iso)
	@qemu-system-x86_64 -cdrom $(iso)

$(iso): $(kernel) $(grub_cfg)
	@mkdir -p build/isofiles/boot/grub
	@cp $(kernel) build/isofiles/boot/kernel.bin
	@cp $(grub_cfg) build/isofiles/booy/grub
	@grub-mkrescue -o $(iso) build/isofiles
	@rm -r build/isofiles

# compile assembly files
build/arch/$(arch)/%.o: src/arch/$(arch)/%.asm
	@mkdir -p $(shell dirname $@)
	@nasm -felf64 $< -o $@
