Chocolatey Packages
===================

[![Build status](https://ci.appveyor.com/api/projects/status/squ0aowdwyqffbc3?svg=true)](https://ci.appveyor.com/project/trajano/choco-packages)

These are Chocolatey packages that I wrote to manage some of my tools.

** THIS DOES NOT PROVIDE ANY OFFICIALLY MAINTAINED CHOCOLATEY PACKAGES **

I am not a package maintainer for Chocolatey please use the official channels for the packages.

## Usage

1. Clone this repository
2. Install choco
3. Run `.\pack.ps1` in a Powershell prompt to create the packages and add the source
4. `choco install <package name>` to install 
5. `choco uninstall <package name>` to uninstall

## Adding to appveyor.yml

The `matrix` section of appveyor.yml takes in a list containing the following:

* `package` which states the name of the package, it corresponds to the package folder that has a `.nuspec` with the same name.
* `local_deps` is an optional `;` separated list of packages that are provided by this project and need to have a pack created first.

## Pull requests

The package name (which is listed in `appveyor.yml` and the title the pull request (case insensitive) must be the same and only the pull request package will be tested on AppVeyor.  Non-pull requests will have all packages tested.

## Packages

The following is a list of my packages and how they differ from the [Chocolatey community maintained packages][].

* `corsair-cue2` Corsair CUE2. **This package is not in [Chocolatey community maintained packages]**
* `eclipse` uses Neon.3 (i.e. 4.6.3) puts the code into `C:\ProgramFiles\Chocolatey\lib\eclipse`, sets the JVM to use the DLL in `jdk` package.
* `eclipse-eclemma` depends on `eclipse` and puts the necessary files into the `dropins` folder.  This provides a sample of how to add plugins into an Eclipse installation.  **This package is not in [Chocolatey community maintained packages]**
* `jd-eclipse` depends on `eclipse` and puts the necessary files into the `dropins` folder.  This provides a sample of how to add plugins into an Eclipse installation.  **This package is not in [Chocolatey community maintained packages]**
* `geforce-game-ready-driver` uses the approach of changing the configuration file rather than deleting the folders and prevents the GeForce Experience, NVidia Update, NView and 3D Vision from being installed.
* `graphviz` uses the zip file install and puts in the proper command line shims.
* `megacmd` MEGAcmd. **This package is not in [Chocolatey community maintained packages]**
* `megasync` MEGAsync. **This package is not in [Chocolatey community maintained packages]**
* `sqlworkbench` SQL Workbench/J. **This package is not in [Chocolatey community maintained packages]**
* `strings` updated to the current version and only keeps the one specific for the architecture.

The following packages are not tested in AppVeyor:

* `corsair-cue2`
* `geforce-game-ready-driver`
* `megasync`

[Chocolatey community maintained packages]: https://chocolatey.org/packages/
