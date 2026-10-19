{
  description = "flake for dots";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

 };

  outputs = { nixpkgs, ...}:
    let
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      # Anonymous function, has inputs, waiting to be fed a function
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
    devShells = forAllSystems (
      system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = pkgs.mkShell {
            nativeBuildInputs = [ pkgs.python3 ];
          shellHook = ''
            export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
          ''; 
           packages = with pkgs; [
            nixd
            uv
            ruff
            ty
           ];
          };
        }
    );
  };
}
