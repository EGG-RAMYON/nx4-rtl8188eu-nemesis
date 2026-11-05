# Maintainer build and verification

The service scripts in `package/` are the reviewed v1.0.3 source files. The kernel module is not committed in this repository. Obtain `r8188eu.ko` from driver Release [`v0.1.0-nx4d1-candidate`](https://github.com/EGG-RAMYON/nx4-rtl8188eu-kmod/releases/tag/v0.1.0-nx4d1-candidate), then verify its SHA-256 against the pinned value before packaging:

```sh
sha256sum r8188eu.ko
# Expected: 0365d9267aa5c1d4c587646bbc354e047f51e9f78424dd4e54e2bbb78e342c02
scripts/build-package.sh ./r8188eu.ko ./dist/nx4.rtl8188eu.manual_v1.0.3.zip
scripts/verify-package.sh ./dist/nx4.rtl8188eu.manual_v1.0.3.zip
scripts/build-usb-installer.sh \
  ./dist/nx4.rtl8188eu.manual_v1.0.3.zip \
  ./dist/NX4_RTL8188EU_NEMESIS_v1.0.3_USB.zip
```

The package builder refuses a module with a different digest. The package verifier checks ZIP integrity, NEMESIS metadata, required files, module digest, and shell syntax/executable bits. The USB builder creates a separate root descriptor with `type=install` and a relative package path.

The driver Release describes the binary as a candidate and does not establish that it is byte-identical to the module used during the reported live network test or reproducible from the current public source. Do not remove that caveat. These host-side checks do not test Android 4.4.2, NEMESIS service control, the vehicle kernel, or Wi-Fi operation.
