# System specific
VENDOR_ROOT = ./bsp/
TOOLCHAIN_ROOT = ./toolchain/bin/

###############################################################################

# Toolchain
CC = $(TOOLCHAIN_ROOT)arm-none-eabi-gcc
DB = $(TOOLCHAIN_ROOT)arm-none-eabi-gdb

# Project sources
SRC_FILES = $(wildcard src/*.c) $(wildcard src/*/*.c)
ASM_FILES = $(wildcard src/*.s) $(wildcard src/*/*.s)
LD_SCRIPT = src/device/stm32f767zitx.ld

# Project includes
INCLUDES   = -Iinc/
INCLUDES  += -Iinc/hal/

# Vendor sources
SRC_FILES += $(VENDOR_ROOT)Drivers/STM32F7xx_HAl_Driver/Src/stm32f7xx_hal.c
SRC_FILES += $(VENDOR_ROOT)Drivers/STM32F7xx_HAl_Driver/Src/stm32f7xx_hal_pwr.c
SRC_FILES += $(VENDOR_ROOT)Drivers/STM32F7xx_HAl_Driver/Src/stm32f7xx_hal_pwr_ex.c
SRC_FILES += $(VENDOR_ROOT)Drivers/STM32F7xx_HAl_Driver/Src/stm32f7xx_hal_rcc.c
SRC_FILES += $(VENDOR_ROOT)Drivers/STM32F7xx_HAl_Driver/Src/stm32f7xx_hal_gpio.c
SRC_FILES += $(VENDOR_ROOT)Drivers/STM32F7xx_HAl_Driver/Src/stm32f7xx_hal_cortex.c

# Vendor includes
INCLUDES += -I$(VENDOR_ROOT)Drivers/CMSIS/Core/Include
INCLUDES += -I$(VENDOR_ROOT)Drivers/CMSIS/Device/ST/STM32F7xx/Include
INCLUDES += -I$(VENDOR_ROOT)Drivers/STM32F7xx_HAl_Driver/Inc
INCLUDES += -I$(VENDOR_ROOT)Drivers/BSP/STM32F7xx_Nucleo_144

# Compiler Flags
CFLAGS  = -g -O0 -Wall -Wextra -Warray-bounds
CFLAGS += -mcpu=cortex-m7 -mthumb -mlittle-endian -mthumb-interwork
CFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16
CFLAGS += -DSTM32F767xx
CFLAGS += $(INCLUDES)

# Linker Flags
LFLAGS = -Wl,--gc-sections -Wl,-T$(LD_SCRIPT)

###############################################################################

# Places all object and binary files into BUILD_DIR, however it cannot detect
# file changes on rebuild and simply rebuilds everything (vpath is probably a
# better solution for out of source builds). To do in source builds, change the
# rules to use the commented lines.

BUILD_DIR = build/
TARGET_EXE = $(BUILD_DIR)main.elf

CXX_OBJS = $(SRC_FILES:.c=.o)
ASM_OBJS = $(ASM_FILES:.s=.o)
OBJS_SRC = $(ASM_OBJS) $(CXX_OBJS)
OBJS_OBJ = $(addprefix $(BUILD_DIR),$(notdir $(OBJS_SRC)))

.PHONY: clean debug

all: $(BUILD_DIR) $(TARGET_EXE)

$(CXX_OBJS): %.o: %.c
$(ASM_OBJS): %.o: %.s
$(OBJS_SRC):
# $(CC) $(CFLAGS) -c $< -o $@
	$(CC) $(CFLAGS) -c $< -o $(addprefix $(BUILD_DIR),$(notdir $@))

$(TARGET_EXE): $(OBJS_SRC)
# $(CC) $(CFLAGS) $(LFLAGS) $(OBJS_SRC) -o $@
	$(CC) $(CFLAGS) $(LFLAGS) $(OBJS_OBJ) -o $@

$(BUILD_DIR):
	mkdir $(BUILD_DIR)

clean:
# rm -f $(OBJS_SRC)
	rm -rf $(BUILD_DIR)

debug:
	$(DB) $(TARGET_EXE)
