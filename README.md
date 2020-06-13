# stm32-makefile

## Overview
This repository contains a blinky project for the STM32 [Nucleo-144 development board](https://www.st.com/en/evaluation-tools/nucleo-f767zi.html) targeting the STM32F767ZI microcontroller. The project uses:
* GNU Make (Build System)
* GNU ARM Embedded Toolchain (Compiler)
* STM32CubeF7 MCU Firmware Package (BSP/Drivers)
* ST-Link or OpenOCD (Debug)

## Motivation
I often need to develop software for STM32 microcontrollers and want to use GNU Make as the build system. While STM bundles example projects and templates in the STM32Cube packages (such as [STM32CubeF7](https://github.com/STMicroelectronics/STM32CubeF7)), the projects do not support GNU Make and instead support IAR, Keil, and Eclipse (Atollic or AC6). These projects also don't include debug configurations. While I enjoy using those tools for navigating code and debugging, I prefer to manage the build system with human readable files as with GNU Make or CMake.

## Existing Solutions
Other projects that address this problem:
* [damheinrich/cm-makefile](https://github.com/adamheinrich/cm-makefile): Makefiles for Cortex-M processors. Not STM32 specific, but should be easily configurable. Overall the level of configurability and complexity is not needed for a small project.
* [STM32-base/STM32-base](https://github.com/STM32-base/STM32-base): Essentially solves the exact problem I have, combining GNU Make with STM32 source code. I tried to use this project but ran into a lot of bugs and problems. At the time of writing I do not have bandwidth to contribute, but eventually should debug this more. It also has more configurability and complexity than needed, since it supports many STM32 devices.

## User Guide

### Setup
* _GNU Make_ - Usually installed by default on Linux and macOS, so no work to do here.
* _GNU ARM Embedded Toolchain_ - Download the toolchain and update the path at the top of the Makefile. If you've added the `bin/` directory of the toolchain to your path then just leave the path empty.
* _STM32CubeF7 MCU Firmware Package_ - This is a submodule of this repository, so it can be downloaded running the commands below. However if you already have it installed on your system, skip the submodule update and just update the path in the Makefile to point to it.
* _ST-Link or OpenOCD_ - For debugging, you will need software that knows how to talk to your debug hardware over USB. On the Nucleo-144 board, there is an ST-Link debugger. You can talk to it using [ST-Link tools](https://github.com/stlink-org/stlink) or [OpenOCD](https://sourceforge.net/p/openocd/code/ci/master/tree/). On Linux I was able to build both of these packages from source easily following the instructions. On macOS both packages were downloadable in binary form using `brew install stlink openocd`.

### Build and Debug
* Simply run `make` to build the project.
* In another terminal, start the debugger backend using one of the [scripts](./scripts).
* Run `make debug` to download the code and start debugging.
