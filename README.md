# Setup

This is my personal Nix configuration, which uses both home-manager and nix-darwin to manage my macOS system.
It makes it easy to set up a new machine, keep machines in sync, and share my configuration with others.

1. Ensure that you have Nix installed locally. The easiest way to do this is with the Determinate Systems Nix installer:
```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```

2. Clone this repository. I like it at `~/.config/nix` and that's where the shell aliases and functions that automate rebuilding expect it to be.

```bash

git clone https://github.com/Hawkbawk/nix-darwin-config ~/.config/nix

```

3. Run `darwin-rebuild switch` to apply the configuration. You won't have this on your PATH yet, so you'll need to either add it to a nix-shell or run it directly. Additionally, because this
messes with your system configuration, you have to run it as sudo.

```bash
sudo nix --extra-experimental-features "nix-command flakes" nix-darwin/nix-darwin-25.05#darwin-rebuild -- switch

```

4. Profit.
