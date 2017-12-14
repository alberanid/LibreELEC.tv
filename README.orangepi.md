# LibreELEC on Orange Pi

This branch updates the material found in http://www.microdev.it/wp/en/2016/08/02/openelec-compilation-for-orange-pi-pc/ to LibreELEC 8.2; their specific license and copyright will apply.

All patches are already applied.


# How to compile

## Docker

Pull the image:

    # docker pull davidealberani/libreelec-orangepi

Build it:

    # ./build-with-docker.sh SYSTEM

where *SYSTEM* can be on of: bpim2p, bx2, opi2, opilite, opione, opipc, opipcplus, opiplus2e, opiplus.

Add-ons can be compiled with:
    # ./build-addon-with-docker.sh SYSTEM name-of-the-addon

where *name-of-the-addon* is one of the directories in *packages/mediacenter/kodi-binary-addons/*


## Manually

Install some dependencies; starts with an Ubuntu 16.04:
    
    # apt-get install build-essential git device-tree-compiler

then compile the images with:

    # ARCH=arm PROJECT=H3 SYSTEM=opiplus2e make image

Add-ons can be compiled with:

    # ARCH=arm PROJECT=H3 SYSTEM=opiplus2e scripts/create_addon name-of-the-addon

# Output

the output can be found in the *target/* directory; the *.img.gz* can be decompressed and written directly to a MicroSD card using *dd*.

