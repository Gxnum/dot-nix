Almost everything is in configuration.nix :p
Make sure to run this command to enable nix-colors before running `sudo nixos-rebuild switch`
```bash
nix-channel --add https://github.com/misterio77/nix-colors/archive/main.tar.gz nix-colors
nix-channel --update
```
