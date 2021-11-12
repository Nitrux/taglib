#!/bin/bash

set -x

### Install Build Tools #1

DEBIAN_FRONTEND=noninteractive apt -qq update
DEBIAN_FRONTEND=noninteractive apt -qq -yy install --no-install-recommends \
	appstream \
	automake \
	autotools-dev \
	build-essential \
	checkinstall \
	cmake \
	curl \
	devscripts \
	equivs \
	extra-cmake-modules \
	gettext \
	git \
	gnupg2 \
	lintian \
	wget

### Install Package Build Dependencies #2

DEBIAN_FRONTEND=noninteractive apt -qq -yy install --no-install-recommends \
	zlib1g-dev \
	libboost-dev \
	libicu-dev \
	pkg-kde-tools \
	doxygen \
	graphviz \
	gsfonts-x11

### Clone repo.

git clone --single-branch --branch v1.12 https://github.com/taglib/taglib.git

rm -rf taglib/{AUTHORS,COPYING.LGPL,COPYING.MPL,INSTALL.md,NEWS,README.md}

### Compile Source

mkdir -p taglib/build && cd taglib/build

cmake \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DBUILD_SHARED_LIBS=ON

make

### Run checkinstall and Build Debian Package
### DO NOT USE debuild, screw it

>> description-pak printf "%s\n" \
	'audio meta-data library.' \
	'' \
	'TagLib is a library for reading and editing audio meta data, commonly know as tags.' \
	'' \
	'This package contains the development headers and runtime package for programs for.' \
	'the TagLib Audio Meta-Data Library.' \
	'' \
	''

checkinstall -D -y \
	--install=no \
	--fstrans=yes \
	--pkgname=taglib \
	--pkgversion=1.12.0 \
	--pkgarch=amd64 \
	--pkgrelease="1" \
	--pkglicense=LGPL-1 \
	--pkggroup=lib \
	--pkgsource=taglib \
	--pakdir=../.. \
	--maintainer=uri_herrera@nxos.org \
	--provides=taglib \
	--requires=libc6,libgcc-s1,libicu66,libstdc++6,zlib1g \
	--nodoc \
	--strip=no \
	--stripso=yes \
	--reset-uids=yes \
	--deldesc=yes
