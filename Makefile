BUILD_ID :=\"$(shell git log -1 --abbrev-commit --pretty=oneline)\"

ARCH  ?= arm64
PLAT  ?= qemu_virt
NCPU  ?= 1
DEBUG ?= 1

ARCH_ASM_OBJS :=
ARCH_OBJS :=
include arch/$(ARCH)/arch.mk

INCLUDE := -Iinclude/ -Ilib/include
INCLUDE += -Iarch/$(ARCH)/include -Iarch/$(ARCH)
INCLUDE += -Iplat/$(PLAT)/

OUTPUT := out

CFLAGS := -nostdlib -nostdinc -ffreestanding -nostartfiles -fno-builtin $(INCLUDE) -march=$(CPU)
CFLAGS += -Wall -Werror
CFLAGS += -DBUILD_ID='"$(BUILD_ID)"' -DNCPU=$(NCPU)

ifeq ($(DEBUG), 1)
	CFLAGS += -g
else
	CFLAGS += -O3
endif

CROSS_COMPILE := ./toolchain/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-elf/bin/aarch64-none-elf

CC := $(CROSS_COMPILE)-gcc
OC := $(CROSS_COMPILE)-objcopy
OD := $(CROSS_COMPILE)-objdump


CORE_KERNEL_OBJS :=
DRIVER_OBJS      :=
LIB_OBJS         :=

include kernel/core.mk
include drivers/drivers.mk
include lib/lib.mk

CORE_KERNEL_OBJS := $(addprefix kernel/, $(CORE_KERNEL_OBJS))
DRIVER_OBJS      := $(addprefix drivers/, $(DRIVER_OBJS))
LIB_OBJS         := $(addprefix lib/, $(LIB_OBJS))
ARCH_OBJS        := $(addprefix arch/$(ARCH)/, $(ARCH_OBJS))

ARCH_ASM_OBJS    := $(addprefix arch/$(ARCH)/, $(ARCH_ASM_OBJS))

ALL_OBJS         := $(addprefix $(OUTPUT)/,$(ARCH_ASM_OBJS) $(ARCH_OBJS) $(CORE_KERNEL_OBJS) $(DRIVER_OBJS) $(LIB_OBJS))
ALL_DIRS         := $(dir $(ALL_OBJS))

define compile_c_targets
$(OUTPUT)/$(1): $(basename $(1)).c
	@$(CC) -c $$^ $(CFLAGS) -o $$@
	@echo "CC\t$$^"
endef

define compile_asm_targets
$(OUTPUT)/$(1): $(basename $(1)).S
	@$(CC) -c $$^ $(CFLAGS) -o $$@
	@echo "CC\t$$^"
endef

default: $(OUTPUT)/kernel.elf

$(foreach f,$(ARCH_ASM_OBJS), $(eval $(call compile_asm_targets,$f)))
$(foreach f,$(ARCH_OBJS) $(CORE_KERNEL_OBJS) $(DRIVER_OBJS) $(LIB_OBJS), $(eval $(call compile_c_targets,$f)))

all_dirs:
	@mkdir -p $(ALL_DIRS)

$(OUTPUT)/linker.ld: linker.ld.S
	@$(CC) -E -P -x c $(INCLUDE) $< > $@
	@echo "GEN\t$@"

$(ALL_OBJS): | all_dirs

$(OUTPUT)/kernel.elf: $(ALL_OBJS) $(OUTPUT)/linker.ld
	@$(CC) -T $(OUTPUT)/linker.ld $(CFLAGS) $(ALL_OBJS) -o $@
	@$(OC) -O binary $@ $(OUTPUT)/kernel.bin
	@$(OD) -d $@ > $(OUTPUT)/kernel.dis
	@
	@echo "OUT\t$@"

clean:
	@rm -rf $(OUTPUT)
	@echo "CLEAN"
