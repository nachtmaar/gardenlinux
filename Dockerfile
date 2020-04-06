FROM 	debian:testing-slim

RUN	apt-get update \
     && apt-get install -y --no-install-recommends \
		debian-ports-archive-keyring \
		debootstrap patch \
		wget ca-certificates \
		\
		gnupg dirmngr \
		qemu-user-static \
		dosfstools squashfs-tools e2fsprogs \
		fdisk mount \
		xz-utils \
     && rm -rf /var/lib/apt/lists/*

# see ".dockerignore"
COPY	. /opt/debuerreotype
RUN	patch -p1 < /opt/debuerreotype/scripts/debootstrap.patch

WORKDIR /opt/debuerreotype/scripts
RUN	for f in debuerreotype-*; do \
		ln -svL "$PWD/$f" "/usr/local/bin/$f"; \
	done; \
	version="$(debuerreotype-version)"; \
	[ "$version" != 'unknown' ]; \
	echo "debuerreotype version $version"

WORKDIR /tmp

