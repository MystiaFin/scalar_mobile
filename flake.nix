{
  description = "Scalar mobile dev shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            android_sdk.accept_license = true;
          };
        };

        android = pkgs.androidenv.composeAndroidPackages {
          platformVersions = [ "34" "35" "36" ];
          buildToolsVersions = [ "34.0.0" "35.0.0" ];
          includeNDK = true;
          includeEmulator = false;
        };

        androidSdk = android.androidsdk;
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            flutter
            jdk17
            androidSdk

            # linux desktop build — keep these ahead of ~/.nix-profile in PATH
            clang
            cmake
            ninja
            pkg-config
            gtk3
          ];

          ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
          ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
          JAVA_HOME = "${pkgs.jdk17}";

          shellHook = ''
            echo "scalar mobile dev shell"
            echo "$(flutter --version | head -1)"
          '';
        };
      });
}
