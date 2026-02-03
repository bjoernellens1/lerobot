{
  description = "LeRobot (SO-ARM101/SO-101) dev shell for NixOS + micromamba";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          # build toolchain (apt: build-essential, cmake, pkg-config, python3-dev)
          gcc
          gnumake
          cmake
          pkg-config
          python310
          python310Packages.pip
          python310Packages.setuptools
          python310Packages.wheel

          # kernel headers (for evdev build)
          linuxHeaders

          # ffmpeg headers/libs (apt: libav*dev, libsw*dev)
          ffmpeg

          # EGL/OpenGL userspace headers/libs (for egl_probe-like builds)
          mesa
          libglvnd

          # common native deps that often pop up during pip builds
          git
          patchelf
          stdenv.cc.cc.lib
          openssl
          zlib

          # conda replacement that behaves well in nix shells
          micromamba
        ];

        # Helpful defaults for the CMake error you hit with egl_probe
        # (modern CMake refuses cmake_minimum_required < 3.5)
        shellHook = ''
          export CMAKE_ARGS="-DCMAKE_POLICY_VERSION_MINIMUM=3.5 ''${CMAKE_ARGS:-}"
          export PIP_NO_BUILD_ISOLATION=1

          # micromamba root in the repo (keeps things self-contained)
          export MAMBA_ROOT_PREFIX="$PWD/.mamba"
          mkdir -p "$MAMBA_ROOT_PREFIX"

          echo "LeRobot dev shell ready."
          echo "Next: run ./setup-lerobot.sh (first time) then 'micromamba activate lerobot'"
        '';
      };
    };
}
