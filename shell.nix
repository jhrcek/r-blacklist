{pkgs ? import ./nixpkgs.nix { }, ghc ? pkgs.haskell.compiler}:

with pkgs;

haskell.lib.buildStackProject ({
  name = "HaskellR";
  inherit ghc;
  buildInputs =
    [ python37Packages.ipython
      python37Packages.jupyter_client
      python37Packages.notebook
      R
      zeromq
      zlib
    ];
  LANG = "en_US.UTF-8";
  LD_LIBRARY_PATH = ["${R}/lib/R/"];
})