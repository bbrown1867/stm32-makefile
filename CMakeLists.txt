cmake_minimum_required(VERSION 3.19.1)

project(stm32-makefile C ASM)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_CROSSCOMPILING 1)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(GCC_PATH ../../../bin/gcc-arm-none-eabi-9-2020-q2-update/bin)
set(CMAKE_C_COMPILER ${GCC_PATH}/arm-none-eabi-gcc CACHE PATH "" FORCE)
set(CMAKE_ASM_COMPILER ${GCC_PATH}/arm-none-eabi-gcc CACHE PATH "" FORCE)

set(VENDOR_ROOT ./bsp)
set(SOURCES 
    src/main.c 
    src/device/system_stm32f7xx.c
    src/device/startup_stm32f767xx.s
    src/hal/stm32f7xx_hal_msp.c
    ${VENDOR_ROOT}/Drivers/BSP/STM32F7xx_Nucleo_144/stm32f7xx_nucleo_144.c
    ${VENDOR_ROOT}/Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal.c
    ${VENDOR_ROOT}/Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_adc.c
    ${VENDOR_ROOT}/Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_adc_ex.c
    ${VENDOR_ROOT}/Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_pwr.c
    ${VENDOR_ROOT}/Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_pwr_ex.c
    ${VENDOR_ROOT}/Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_rcc.c
    ${VENDOR_ROOT}/Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_rcc_ex.c
    ${VENDOR_ROOT}/Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_spi.c
    ${VENDOR_ROOT}/Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_dma.c
    ${VENDOR_ROOT}/Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_gpio.c
    ${VENDOR_ROOT}/Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_uart.c
    ${VENDOR_ROOT}/Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_cortex.c
    ${VENDOR_ROOT}/Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_exti.c
)

include_directories(
    inc/
    inc/hal
    ${VENDOR_ROOT}/Drivers/CMSIS/Core/Include
    ${VENDOR_ROOT}/Drivers/CMSIS/Device/ST/STM32F7xx/Include
    ${VENDOR_ROOT}/Drivers/STM32F7xx_HAL_Driver/Inc
    ${VENDOR_ROOT}/Drivers/BSP/STM32F7xx_Nucleo_144
)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -O0 -Wall -Wextra -Warray-bounds")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mcpu=cortex-m7 -mthumb")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mlittle-endian -mthumb-interwork")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mfloat-abi=hard -mfpu=fpv4-sp-d16")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DSTM32F767xx")

set(LD_SCRIPT "${PROJECT_SOURCE_DIR}/src/device/stm32f767zitx.ld")
set(CMAKE_EXE_LINKER_FLAGS "-Wl,--gc-sections -Wl,-T${LD_SCRIPT} --specs=rdimon.specs")

add_executable(main.elf ${SOURCES})
