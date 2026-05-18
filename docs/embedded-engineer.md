# 🔌 Embedded Engineer Tooling Guide

> Everything you need to go from bare silicon to shipping firmware — on Ubuntu.

---

## 🧰 What Gets Installed

The `embedded` module installs a complete embedded development environment:

### Cross-Compilation Toolchains

| Toolchain | Target | Use Case |
|-----------|--------|----------|
| `gcc-arm-none-eabi` | ARM Cortex-M (bare-metal) | STM32, TI MSP432, nRF52, etc. |
| `gcc-aarch64-linux-gnu` | ARM Cortex-A (64-bit Linux) | Raspberry Pi 4, Jetson, Zynq UltraScale+ |
| `gcc-arm-linux-gnueabihf` | ARM Cortex-A (32-bit Linux) | BeagleBone, RPi 3, older SoCs |

### Emulation

| Tool | Purpose |
|------|---------|
| `qemu-system-arm` | Emulate ARM Cortex-M/A boards |
| `qemu-system-aarch64` | Emulate 64-bit ARM (test without hardware) |
| `qemu-user-static` | Run ARM binaries on x86 (for cross-testing) |

### Debug & Flash

| Tool | Purpose |
|------|---------|
| `openocd` | JTAG/SWD debug server (ST-Link, J-Link, FTDI) |
| `gdb-multiarch` | GDB for any architecture |
| `minicom` / `picocom` | Serial console (UART) |

### Build Systems for Embedded Linux

| Tool | Purpose |
|------|---------|
| Yocto dependencies | Build custom Linux distributions |
| `kas` | Yocto build orchestrator (multi-layer management) |
| `device-tree-compiler` | Compile/decompile device tree blobs |
| `doxygen` + `graphviz` | Generate documentation from code |

---

## 🏗️ Yocto Project — Building Custom Linux

### What is Yocto?

Yocto builds a complete Linux distribution from source — kernel, rootfs, packages, everything — tailored to your hardware. It's how companies like Tesla, John Deere, and every automotive OEM build their embedded Linux.

### Prerequisites (installed by this module)

```bash
# These are the Yocto host dependencies:
gawk wget git diffstat unzip texinfo gcc build-essential
chrpath socat cpio python3 python3-pip python3-pexpect
xz-utils debianutils iputils-ping python3-git python3-jinja2
python3-subunit zstd liblz4-tool file locales libacl1
```

### Quick Start with kas

```bash
# Clone a BSP layer (example: Raspberry Pi)
git clone -b scarthgap git://git.yoctoproject.org/poky
cd poky

# Source the build environment
source oe-init-build-env

# Build a minimal image
bitbake core-image-minimal

# Or use kas for multi-layer projects:
kas build kas-config.yml
```

### Yocto Tips

```bash
# Check available machines
ls meta*/conf/machine/*.conf

# Build SDK for cross-development
bitbake -c populate_sdk core-image-minimal

# Clean a recipe
bitbake -c cleansstate my-recipe

# Open a devshell (chroot into build environment)
bitbake -c devshell my-recipe

# Find which recipe provides a package
oe-pkgdata-util find-path /usr/bin/something
```

### Anecdote
> *"My first Yocto build took 6 hours and 80GB of disk. My second took 20 minutes (sstate cache). The lesson: never delete your build directory, and always set up a shared sstate mirror for your team."*

---

## 🔧 Buildroot — The Lighter Alternative

When Yocto is overkill (small systems, quick prototypes):

```bash
git clone https://github.com/buildroot/buildroot.git
cd buildroot
make raspberrypi4_64_defconfig
make menuconfig    # Configure your system
make -j$(nproc)    # Build everything
# Output: output/images/sdcard.img
```

**Yocto vs Buildroot:**
| | Yocto | Buildroot |
|---|-------|-----------|
| Learning curve | Steep | Moderate |
| Build time (first) | Hours | 30-60 min |
| Package management | Yes (opkg/rpm/deb) | No (static rootfs) |
| Layer system | Yes (reusable BSPs) | No |
| OTA updates | Yes (SWUpdate, RAUC) | Manual |
| Best for | Production products | Prototypes, small systems |

---

## 📡 Serial Communication

### minicom

```bash
# Connect to serial port
minicom -D /dev/ttyUSB0 -b 115200

# Inside minicom:
# Ctrl+A Z    → Help menu
# Ctrl+A X    → Exit
# Ctrl+A L    → Capture to file
# Ctrl+A E    → Local echo toggle
```

### picocom (simpler, recommended)

```bash
# Connect
picocom -b 115200 /dev/ttyUSB0

# Exit: Ctrl+A Ctrl+X
# No config files, no menus, just works.
```

### Permissions

```bash
# If you get "Permission denied":
sudo usermod -aG dialout $USER
# Log out and back in

# Verify:
ls -la /dev/ttyUSB0
# Should show group: dialout
```

### Anecdote
> *"I once spent an hour debugging why my serial output was garbage. Baud rate was right, wiring was right. Turns out I had flow control enabled in minicom and the target didn't support it. picocom doesn't have this problem — it defaults to no flow control. Keep it simple."*

---

## 🐛 Debugging with OpenOCD + GDB

### Flash and Debug STM32

```bash
# Start OpenOCD (connects to ST-Link)
openocd -f interface/stlink.cfg -f target/stm32f4x.cfg

# In another terminal, connect GDB
arm-none-eabi-gdb build/firmware.elf
(gdb) target remote :3333
(gdb) monitor reset halt
(gdb) load
(gdb) break main
(gdb) continue
```

### Flash and Debug TI (XDS110)

```bash
openocd -f interface/xds110.cfg -f target/ti_am64x.cfg
```

### Flash and Debug via J-Link

```bash
openocd -f interface/jlink.cfg -f target/stm32f4x.cfg -c "transport select swd"
```

### Common GDB Commands for Embedded

```
break main              # Breakpoint at main
break *0x08000100       # Breakpoint at address
info registers          # Show CPU registers
x/16xw 0x40020000      # Examine 16 words at peripheral address
monitor reset halt      # Reset target
monitor flash write_image erase firmware.bin 0x08000000  # Flash binary
```

---

## 🖥️ QEMU — Test Without Hardware

### Emulate Cortex-M (STM32-like)

```bash
qemu-system-arm -machine lm3s6965evb -kernel firmware.elf -nographic
# Ctrl+A X to exit
```

### Emulate Cortex-A (Linux)

```bash
# Boot a Yocto image in QEMU
runqemu qemuarm64 nographic
```

### Emulate Raspberry Pi

```bash
qemu-system-aarch64 \
  -machine raspi3b \
  -kernel kernel8.img \
  -dtb bcm2710-rpi-3-b.dtb \
  -drive file=rootfs.img,format=raw \
  -append "console=ttyAMA0 root=/dev/mmcblk0p2" \
  -nographic
```

### Anecdote
> *"QEMU saved me when the hardware prototype was delayed by 3 weeks. I developed and tested the entire application layer in QEMU, and when the boards arrived, it booted first try. Emulation isn't a substitute for hardware — but it's a force multiplier."*

---

## 📋 Platform-Specific Notes

### STM32 (ST Microelectronics)

```bash
# Tools: arm-none-eabi-gcc, OpenOCD, STM32CubeMX (Java app)
# Debug probe: ST-Link V2/V3
# Framework: STM32 HAL / LL / bare-metal CMSIS
```

### TI (AM64x, MSP432, CC3220)

```bash
# Tools: arm-none-eabi-gcc or TI's arm-cgt compiler
# Debug probe: XDS110 (on-board most LaunchPads)
# SDK: TI MCU+ SDK, Processor SDK Linux
# Note: TI's CCS (Code Composer Studio) is Eclipse-based, runs on Linux
```

### BeagleBone

```bash
# Tools: gcc-arm-linux-gnueabihf (Linux userspace)
# Boot: U-Boot + Device Tree
# Image: Debian-based (official) or Yocto
# Access: SSH over USB (192.168.7.2)
```

### Xilinx Zynq (FPGA + ARM)

```bash
# Tools: Vivado/Vitis (Xilinx IDE), PetaLinux (Yocto-based)
# Cross-compiler: aarch64-linux-gnu-gcc
# Workflow: FPGA bitstream + Linux kernel + rootfs
# Note: PetaLinux requires Ubuntu (officially supported)
```

### NVIDIA Jetson

```bash
# Tools: NVIDIA SDK Manager (installs JetPack)
# Cross-compiler: aarch64-linux-gnu-gcc
# Framework: CUDA, TensorRT, DeepStream
# Flash: nvidia-l4t-tools
# Note: SDK Manager only runs on Ubuntu x86_64 host
```

---

## 🔄 Typical Embedded Workflow

```
1. Write code (Vim/VS Code + clangd LSP)
2. Cross-compile (arm-none-eabi-gcc / CMake)
3. Flash (OpenOCD / vendor tool)
4. Debug (GDB + OpenOCD)
5. Monitor (picocom / minicom for UART)
6. Test (QEMU for CI, hardware for validation)
7. Build image (Yocto / Buildroot for Linux targets)
8. Deploy (OTA update / SD card / network boot)
```

---

*"Embedded development is 10% writing code and 90% figuring out why the hardware isn't doing what the datasheet says it should."*
