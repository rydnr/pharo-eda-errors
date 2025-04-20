{
  description = "Flake for rydnr/pharo-eda-errors";

  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";
    pharo-vm-12 = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:rydnr/nix-flakes/pharo-vm-12.0.1519.4?dir=pharo-vm";
    };
    pharo-eda-common-12 = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:rydnr/pharo-eda-common/0.1.1";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        org = "rydnr";
        repo = "pharo-eda-errors";
        pname = "${repo}";
        tag = "0.1.0";
        baseline = "PharoEDAErrors";
        pkgs = import nixpkgs { inherit system; };
        description = "Error handling mechanisms for PharoEDA";
        license = pkgs.lib.licenses.gpl3;
        homepage = "https://github.com/rydnr/pharo-eda-errors";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsVersion = builtins.readFile "${nixpkgs}/.version";
        nixpkgsRelease =
          builtins.replaceStrings [ "\n" ] [ "" ] "nixpkgs-${nixpkgsVersion}";
        shared = import ./nix/shared.nix;
        pharo-eda-errors-for = { bootstrap-image-name, bootstrap-image-sha256, bootstrap-image-url, pharo-vm, pharo-eda-common }:
          let
            bootstrap-image = pkgs.fetchurl {
              url = bootstrap-image-url;
              sha256 = bootstrap-image-sha256;
            };
            src = ./src;
          in pkgs.stdenv.mkDerivation (finalAttrs: {
            version = tag;
            inherit pname src;

            strictDeps = true;

            buildInputs = with pkgs; [
            ];

            nativeBuildInputs = with pkgs; [
              pharo-vm
              pkgs.unzip
            ];

            unpackPhase = ''
              unzip -o ${bootstrap-image} -d image
              cp -r ${src} src
              mkdir -p $out/share/src/${pname}
            '';

            configurePhase = ''
              runHook preConfigure

              substituteInPlace src/BaselineOfPharoEDAErrors/BaselineOfPharoEDAErrors.class.st \
                --replace-fail "github://rydnr/pharo-eda-common:main" "tonel://${pharo-eda-common}/share/src/pharo-eda-common"

              # load baseline
              ${pharo-vm}/bin/pharo image/${bootstrap-image-name} eval --save "EpMonitor current disable. NonInteractiveTranscript stdout install. [ Metacello new repository: 'tonel://$PWD/src'; baseline: '${baseline}'; onConflictUseLoaded; load ] ensure: [ EpMonitor current enable ]"

              runHook postConfigure
            '';

            buildPhase = ''
              runHook preBuild

              # assemble
              ${pharo-vm}/bin/pharo image/${bootstrap-image-name} save "${pname}"

              mkdir dist
              mv image/${pname}.* dist/

              runHook postBuild
            '';

            installPhase = ''
              runHook preInstall

              mkdir -p $out
              cp -r ${pharo-vm}/bin $out
              cp -r ${pharo-vm}/lib $out
              cp -r dist/* $out/
              cp image/*.sources $out/
              pushd src
              cp -r . $out/share/src/${pname}
              ${pkgs.zip}/bin/zip -r $out/share/src.zip .
              popd

              runHook postInstall
             '';

            meta = {
              changelog = "https://github.com/rydnr/pharo-eda-errors/releases/";
              longDescription = ''
                    Error handling mechanisms for PharoEDA.
              '';
              inherit description homepage license maintainers;
              mainProgram = "pharo";
              platforms = pkgs.lib.platforms.linux;
            };
        });
      in rec {
        defaultPackage = packages.default;
        devShells = rec {
          default = pharo-eda-errors-12;
          pharo-eda-errors-12 = shared.devShell-for {
            package = packages.pharo-eda-errors-12;
            inherit org pkgs repo tag;
            nixpkgs-release = nixpkgsRelease;
          };
        };
        packages = rec {
          default = pharo-eda-errors-12;
          pharo-eda-errors-12 = pharo-eda-errors-for rec {
            bootstrap-image-url = pharo-vm-12.resources.${system}.bootstrap-image-url;
            bootstrap-image-sha256 = pharo-vm-12.resources.${system}.bootstrap-image-sha256;
            bootstrap-image-name = pharo-vm-12.resources.${system}.bootstrap-image-name;
            pharo-eda-common = pharo-eda-common-12.packages.${system}.pharo-eda-common-12;
            pharo-vm = pharo-vm-12.packages.${system}.pharo-vm;
          };
        };
      });
}
