#!/bin/sh

source config/version

BUILD_DIR="build.LibreELEC-H3.arm-${OS_VERSION}"

if [ -n "${LIBREELEC_VERSION}" ] ; then
	BUILD_DIR="${BUILD_DIR}-${LIBREELEC_VERSION}"
fi

WD="`pwd`"

mkdir -p "${WD}/target"
mkdir -p "${WD}/sources"
mkdir -p "${WD}/${BUILD_DIR}"

docker run \
	-it \
	--rm \
	--name orange-build \
	-v "${WD}/target:/home/orangepi/target" \
	-v "${WD}/sources:/home/orangepi/sources" \
	-v "${WD}/${BUILD_DIR}:/home/orangepi/${BUILD_DIR}" \
	--entrypoint "./entrypoint-for-addons.sh" \
	davidealberani/libreelec-orangepi $@

