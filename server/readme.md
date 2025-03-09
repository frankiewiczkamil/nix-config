```sh
 nix build ./server#nixosConfigurations.rpi3.config.system.build.sdImage \\
    --system aarch64-linux \\
    --print-out-paths \\
    --max-jobs 0
```

```sh
diskutil list
```

```sh
sudo umount /dev/sdX
sudo mkfs.ext4 -L NIXOS_SD /dev/sdX
sudo e2label /dev/diskX
```

```sh
sudo dd if=./result/sd-image/nixos-sd-image-24.11.20250305.a460ab3-aarch64-linux.img  of=/dev/disk5 bs=1M status=progress
```
