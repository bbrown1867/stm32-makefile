# System specific configuration
VENDOR_ROOT = ./bsp/
TOOLCHAIN_ROOT = ./toolchain/bin/

###############################################################################

# Project specific
TARGET_FILE = main.elf
SRC_DIR = src/
INC_DIR = inc/
BUILD_DIR = build/

# Toolchain
CC = $(TOOLCHAIN_ROOT)arm-none-eabi-gcc
DB = $(TOOLCHAIN_ROOT)arm-none-eabi-gdb

# Project sources
SRC_FILES = $(wildcard $(SRC_DIR)*.c) $(wildcard $(SRC_DIR)*/*.c)
ASM_FILES = $(wildcard $(SRC_DIR)*.s) $(wildcard $(SRC_DIR)*/*.s)
LD_SCRIPT = $(SRC_DIR)/device/stm32f767zitx.ld

# Project includes
INCLUDES   = -I$(INC_DIR)
INCLUDES  += -I$(INC_DIR)hal/

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

# This does an in-source build. An out-of-source build that places all object
# files into BUILD_DIR would be a better solution, but the goal was to keep
# this file very simple.

CXX_OBJS = $(SRC_FILES:.c=.o)
ASM_OBJS = $(ASM_FILES:.s=.o)
ALL_OBJS = $(ASM_OBJS) $(CXX_OBJS)
TARGET_ELF = $(BUILD_DIR)$(TARGET_FILE)

.PHONY: clean debug

all: $(BUILD_DIR) $(TARGET_ELF)

# Compile
$(CXX_OBJS): %.o: %.c
$(ASM_OBJS): %.o: %.s
$(ALL_OBJS):
	$(CC) $(CFLAGS) -c $< -o $@

# Link
$(TARGET_ELF): $(ALL_OBJS)
	$(CC) $(CFLAGS) $(LFLAGS) $(ALL_OBJS) -o $@

# Make build directory
$(BUILD_DIR):
	mkdir $(BUILD_DIR)

# Clean
clean:
	rm -f $(ALL_OBJS)
	rm -rf $(BUILD_DIR)

# Debug
debug:
	$(DB) $(TARGET_EXE)
