Chocolatey Packages
===================

[![Build status](https://ci.appveyor.com/api/projects/status/squ0aowdwyqffbc3?svg=true)](https://ci.appveyor.com/project/trajano/choco-packages)

These are Chocolatey packages that I wrote to manage some of my tools.

** THIS DOES NOT PROVIDE AN OFFICIALLY MAINTAINED CHOCOLATEY PACKAGE **

I am not a package maintainer for Chocolatey please use the official channels for the packages.

## Usage

1. Clone this repository
2. Install choco
3. In powershell as administrator run `cd [package] ; choco install [package.nuspec]` to install
4. In powershell as administrator run `choco uninstall [package]` to uninstall

## Adding to appveyor.yml

The `matrix` section of appveyor.yml takes in a list containing the following:

* `package` which states the name of the package, it corresponds to the package folder that has a `.nuspec` with the same name.
* `local_deps` is an optional `;` separated list of packages that are provided by this project and need to have a pack created first.
