{
  description = "tmux session to have all the *top utilities I use in one place";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    batmon = {
        url = "github:6543/batmon";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (let 
        name = "dash";
    in {
      imports = [ ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {

          packages.default = pkgs.writeShellApplication {
              inherit name;

              runtimeInputs = let 
                batmon = inputs'.batmon.packages.default;
              in [ pkgs.tmux pkgs.bottom pkgs.peaclock pkgs.alsa-utils batmon ];

              text = /*bash*/ ''
                SESSION="${name}"
                if ! tmux ls | grep -q dash ; then
                    tmux new-session -d -s $SESSION btm
                    tmux split-window -h -t $SESSION:0.0 peaclock
                    tmux split-window -v -t $SESSION:0.1 batmon
                    tmux split-window -h -t $SESSION:0.1 alsamixer
                    tmux select-pane -t $SESSION:0.2
                fi
                tmux attach -t $SESSION
              '';
          };

          apps.default = { 
              type = "app";
              program = self'.packages.default;
          };
      };
      flake = { };
    });
}
