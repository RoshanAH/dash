[![dependency status](https://deps.rs/repo/github/viperML/nh/status.svg)](https://deps.rs/repo/github/viperML/nh)

<h1 align="center">dash</h1>

## What is it?

dash is nothing too complicated. It uses [tmux](https://github.com/tmux/tmux) to display a few of my most commonly used *top utilities all in one place. This project is really for me to get more comfortable with nix dev environments and managing flakes.

## Preview

<p align="center">
  <img
    alt="build: passing"
    src="./.github/screenshot.png"
    width="800px"
  >
</p>


## Installation

Install dash as you would a regular flake.

`flake.nix`
```nix
{

  inputs = {
    # ...
    dash.url = "github:RoshanAH/dash"; # include dash as an input
  };

  outputs = { nixpkgs, ... }@inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
      ];
    };
  };
  
}
```
`configuration.nix`
```nix

{inputs, pkgs, ...}: {
    # ...
    environment.systemPackages = (with pkgs; [
        # ...
    ]) ++ [
        inputs.dash.packages.${pkgs.stdenv.hostPlatform.system}.default
    ]; 
    # ...
}

```

## Hacking

Just `nix develop`.
