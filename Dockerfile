FROM ubuntu:16.04

LABEL \
	maintainer="Davide Alberani <da@erlug.linux.it>"

VOLUME \
	./target:/home/orangepi/target \
	./sources:/home/orangepi/sources

RUN \
	apt-get update && \
	apt-get -y --no-install-recommends install \
		bc \
		build-essential \
		default-jre \
		device-tree-compiler \
		gawk \
		gperf \
		libexpat1-dev \
		libjson-perl \
		libncurses5-dev \
		lzop \
		patchutils \
		texinfo \
		unzip \
		wget \
		xfonts-utils \
		xsltproc \
		zip && \
	echo "yes" | cpan && \
	cpan -i XML::Parser && \
	rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash orangepi

USER orangepi:orangepi

COPY . /home/orangepi

WORKDIR /home/orangepi

ENV \
	ARCH=arm \
	PROJECT=H3

ENTRYPOINT ["./build4orangepi"]
