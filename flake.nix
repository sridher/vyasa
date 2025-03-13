{
  description = "Linux kernel environment";

  inputs = {
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/5135c59491985879812717f4c9fea69604e7f26f";
    flake-parts.url = "github:hercules-ci/flake-parts/af510d4a62d071ea13925ce41c95e3dec816c01d";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        # To import a flake module
        # 1. Add foo to inputs
        # 2. Add foo as a parameter to the outputs function
        # 3. Add here: foo.flakeModule
      ];
      systems = ["x86_64-linux" "aarch64-darwin"];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.

        # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
        #packages.default = pkgs.hello;
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [
            pkgs.bc
            pkgs.flex
            pkgs.bison
            pkgs.ncurses

            #pkgs.gcc

            pkgs.autoconf
            pkgs.automake
            pkgs.gettext
            pkgs.libtool

            pkgs.gnumake
            pkgs.elfutils
            pkgs.openssl
            #pkgs.stdenv

            #pkgs.libxcrypt

            pkgs.grub2
            pkgs.libnbd
            pkgs.libguestfs
            pkgs.qemu-utils
            #pkgs.qemu_full
            #pkgs.debootstrap

            pkgs.lld_19
            pkgs.clang_19
            pkgs.clang-tools_19
            pkgs.llvmPackages_19.libllvm

            pkgs.starship
          ];
          shellHook = ''
            export 'name=Linux kernel - flake'
            export IN_NIX_SHELL=pure
            echo ""
            echo "------------------------"
            echo "Starting Linux kernel environment..."
          '';
        };
      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.
      };
    };
}
