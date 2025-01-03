### init

```shell
git clone https://github.com/frankiewiczkamil/nix-config.git
```

```shell
nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake ./mac#mac1 --show-trace

# or mac2/mac3/...
```

### update

```shell
nix flake update --flake ./mac/flake.nix
```

```bash
darwin-rebuild switch --flake ./mac#mac1 --show-trace

# or mac2/mac3/...
```
