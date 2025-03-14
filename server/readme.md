## Build image

```
 nix build ./server#nixosConfigurations.rpi3.config.system.build.sdImage \
    --system aarch64-linux \
    --print-out-paths \
    --max-jobs 0
```

This should create an img in result folder, like `./result/sd-image/nixos-sd-image-something-aarch64-linux.img`

## Save image

### Prepare the sd card (optional)

This is required only for the first time

```sh
diskutil list # check sd card disk device, eg. /dev/disk4
nix-shell -p e2fsprogs # we'll need some tools
sudo umount /dev/diskX # unmount sd card
sudo mkfs.ext4 -L NIXOS_SD /dev/diskX # set disk label
sudo e2label /dev/diskX # verify disk label
```

### Create bootable sd card

```sh
sudo dd if=./result/sd-image/nixos-sd-image-something-aarch64-linux.img of=/dev/diskX bs=1M status=progress
```

## Remote upgrade

The following command

```
nix build ./server#nixosConfigurations.rpi3.config.system.build.toplevel --system aarch64-linux --print-out-paths --max-jobs 0
```

should log a path, like eg. `/nix/store/hk829d63n1brg0fdi0dm3l1yk5nr30gf-nixos-system-pikachu-24.11.20250305.a460ab3`

which we use deploy to the `pi` host, like:

```sh
nix-copy-closure --to pi@192.168.1.14 /nix/store/some-path -v -v
```

then we log to the `pi` host

```sh
ssh pi@192.168.1.14
```

and call reinstall command:

```sh
sudo nixos-install --root / --system /nix/store/some-path --no-bootloader
```

the list of existing upgrades can be checked using

```sh
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

ssh pi@192.168.1.14 "echo 'sudo nixos-install --root / --system /nix/store/rcdnxpfznfp04m0vh02rv1359sjp0vfs-nixos-system-raichu-24.11.20250305.a460ab3' | at now + 3 seconds"
