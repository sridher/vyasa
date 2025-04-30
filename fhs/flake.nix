{
  description = "Linux kernel environment";

  inputs = {
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs.url = "github:nixos/nixpkgs/b024ced1aac25639f8ca8fdfc2f8c4fbd66c48ef";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    fhs = pkgs.buildFHSEnv {
      name = "vyasa-fhs";
      targetPkgs = pkgs: [
        #pkgs.llvmPackages_20.libllvm #libllvm
        #pkgs.llvmPackages_20.compiler-rt
        #pkgs.llvmPackages_20.bintools
        #pkgs.llvmPackages_20.libunwind
        ##pkgs.llvmPackages_20.libcxxabi
        #pkgs.llvmPackages_20.libcxx
        #pkgs.llvmPackages_20.clang
        #pkgs.llvmPackages_20.lld
        ##pkgs.libtool

        pkgs.bc
        pkgs.flex
        pkgs.bison
        pkgs.ncurses

        pkgs.gcc14

        pkgs.autoconf
        pkgs.automake
        #pkgs.gettext
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
        pkgs.debootstrap

        pkgs.starship
      ];
      runScript = pkgs.writeScript "init.sh" ''
        export 'name=Vyasa FHS - flake'
        export IN_NIX_SHELL=pure
        echo ""
        echo "------------------------"
        echo "Starting Vyasa FHS environment..."
        exec bash
      '';
    };
  in {
    devShells.${system}.default = fhs.env;
  };
}
