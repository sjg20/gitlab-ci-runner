# SPDX-License-Identifier: GPL-2.0+
# This Dockerfile is used to build an image containing basic stuff to be used
# to build U-Boot and run our test suites.

FROM ubuntu:xenial-20190222
MAINTAINER Tom Rini <trini@konsulko.com>
LABEL Description=" This image is for building U-Boot inside a container"

# Make sure apt is happy
ENV DEBIAN_FRONTEND=noninteractive

# Add LLVM repository
RUN apt-get update && apt-get install -y wget xz-utils && rm -rf /var/lib/apt/lists/*
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN echo deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-7 main | tee /etc/apt/sources.list.d/llvm.list

# Manually install the kernel.org "Crosstool" based toolchains for gcc-7.3
RUN wget -O - https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin/x86_64/7.3.0/x86_64-gcc-7.3.0-nolibc_aarch64-linux.tar.xz | tar -C /opt -xJ
RUN wget -O - https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin/x86_64/7.3.0/x86_64-gcc-7.3.0-nolibc_arm-linux-gnueabi.tar.xz | tar -C /opt -xJ
RUN wget -O - https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin/x86_64/7.3.0/x86_64-gcc-7.3.0-nolibc_i386-linux.tar.xz | tar -C /opt -xJ
RUN wget -O - https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin/x86_64/7.3.0/x86_64-gcc-7.3.0-nolibc_m68k-linux.tar.xz | tar -C /opt -xJ
RUN wget -O - https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin/x86_64/7.3.0/x86_64-gcc-7.3.0-nolibc_mips-linux.tar.xz | tar -C /opt -xJ
RUN wget -O - https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin/x86_64/7.3.0/x86_64-gcc-7.3.0-nolibc_microblaze-linux.tar.xz | tar -C /opt -xJ
RUN wget -O - https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin/x86_64/7.3.0/x86_64-gcc-7.3.0-nolibc_nios2-linux.tar.xz | tar -C /opt -xJ
RUN wget -O - https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin/x86_64/7.3.0/x86_64-gcc-7.3.0-nolibc_powerpc-linux.tar.xz | tar -C /opt -xJ
RUN wget -O - https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin/x86_64/7.3.0/x86_64-gcc-7.3.0-nolibc_riscv64-linux.tar.xz | tar -C /opt -xJ
RUN wget -O - https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin/x86_64/7.3.0/x86_64-gcc-7.3.0-nolibc_sh2-linux.tar.xz | tar -C /opt -xJ

# Manually install other toolchains
RUN wget -O - https://github.com/foss-xtensa/toolchain/releases/download/2018.02/x86_64-2018.02-xtensa-dc233c-elf.tar.gz | tar -C /opt -xz
RUN wget -O - https://github.com/foss-for-synopsys-dwc-arc-processors/toolchain/releases/download/arc-2018.09-release/arc_gnu_2018.09_prebuilt_uclibc_le_archs_linux_install.tar.gz | tar -C /opt -xz
RUN wget -O - https://github.com/vincentzwc/prebuilt-nds32-toolchain/releases/download/20180521/nds32le-linux-glibc-v3-upstream.tar.gz | tar -C /opt -xz

# Updat and install things from apt now
RUN apt-get update && apt-get install -y \
	bc \
	bison \
	build-essential \
	clang-7 \
	cpio \
	cppcheck \
	curl \
	device-tree-compiler \
	dosfstools \
	e2fsprogs \
	flex \
	gdisk \
	git \
	grub-efi-amd64-bin \
	grub-efi-ia32-bin \
	iasl \
	iputils-ping \
	liblz4-tool \
	libpixman-1-dev \
	libpython-dev \
	libsdl1.2-dev \
	libssl-dev \
	libudev-dev \
	libusb-1.0-0-dev \
	lzop \
	picocom \
	python \
	python-coverage \
	python-dev \
	python-pip \
	python-pytest \
	python-virtualenv \
	rpm2cpio \
	sloccount \
	sparse \
	srecord \
	sudo \
	swig \
	virtualenv \
	zip \
	&& rm -rf /var/lib/apt/lists/*

# Create the buildman config file
RUN /bin/echo -e "[toolchain]\nroot = /usr" > ~/.buildman
RUN /bin/echo -e "kernelorg = /opt/gcc-7.3.0-nolibc/*" >> ~/.buildman
RUN /bin/echo -e "arc = /opt/arc_gnu_2018.09_prebuilt_uclibc_le_archs_linux_install" >> ~/.buildman
RUN /bin/echo -e "\n[toolchain-prefix]\nxtensa = /opt/2018.02/xtensa-dc233c-elf/bin/xtensa-dc233c-elf-" >> ~/.buildman;
RUN /bin/echo -e "\nnds32 = /opt/nds32le-linux-glibc-v3-upstream/bin/nds32le-linux-" >> ~/.buildman;
RUN /bin/echo -e "\n[toolchain-alias]\nsh = sh2" >> ~/.buildman
RUN /bin/echo -e "\nriscv = riscv64" >> ~/.buildman
RUN /bin/echo -e "\nsandbox = x86_64" >> ~/.buildman
RUN /bin/echo -e "\nx86 = i386" >> ~/.buildman;
