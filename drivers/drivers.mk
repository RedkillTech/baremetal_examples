ifeq ($(CONFIG_AJIT), 1)
DRIVER_OBJS += uart/ajit_serial.o
else
DRIVER_OBJS += uart/pl011.o
endif
