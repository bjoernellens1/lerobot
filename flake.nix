{
  description = "LeRobot (SO-ARM101/SO-101) on NixOS via micromamba in FHS shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      # FHS environment: provides /bin/bash + standard loader paths
      lerobotFhs = pkgs.buildFHSEnv {
        name = "lerobot-fhs";
        targetPkgs = pkgs: with pkgs; [
          bashInteractive
          coreutils
          which
          git

          # runtime libs commonly needed by conda binaries
          stdenv.cc.cc.lib
          zlib
          openssl
          libffi
          glib

          # EGL/OpenGL userspace (for egl_probe-like deps)
          mesa
          libglvnd

          # kernel headers for evdev build
          linuxHeaders
        ];
        runScript = "bash";
      };
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          lerobotFhs

          # build deps for pip compiling native packages
          gcc
          gnumake
          cmake
          pkg-config
          linuxHeaders
          ffmpeg

          # micromamba (we’ll run it inside the FHS shell)
          micromamba
        ];

        shellHook = ''
          export MAMBA_ROOT_PREFIX="$PWD/.mamba"
          mkdir -p "$MAMBA_ROOT_PREFIX"

          # helps the CMake policy issue you hit
          export CMAKE_ARGS="-DCMAKE_POLICY_VERSION_MINIMUM=3.5 ''${CMAKE_ARGS:-}"
          export PIP_NO_BUILD_ISOLATION=1

          echo "Dev shell ready."
          echo "Next:"
          echo "  lerobot-fhs"
          echo "  ./setup-lerobot.sh"
        '';
      };
    };
}
