# LibreELEC on Orange Pi

This branch updates the material found in http://www.microdev.it/wp/en/2016/08/02/openelec-compilation-for-orange-pi-pc/ to LibreELEC 8.2.

All patches are already applied.


# How to compile

Install some dependencies; starts with an Ubuntu 16.04:
    
    # apt-get install build-essential device-tree-compiler

then compile the images with:

    # ARCH=arm PROJECT=H3 SYSTEM=opiplus2e make image

where *SYSTEM* can be on of: bpim2p, bx2, opi2, opilite, opione, opipc, opipcplus, opiplus2e, opiplus.

You can also compile the binaries add-ons with:

    # ARCH=arm PROJECT=H3 SYSTEM=opiplus2e scripts/create_addon name-of-the-plugin

where *name-of-the-plugin* is one of the directories in *packages/mediacenter/kodi-binary-addons/*

# Output

the output can be found in the *target/* directory; the *.img.gz* can be decompressed and written directly to a MicroSD card using *dd*.

