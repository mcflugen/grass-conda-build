# Anaconda distribution of GRASS

## Get a minimal anaconda installation

If you don't already have an Anaconda distribution on your machine,
you will need to install one.

    $ curl https://repo.continuum.io/miniconda/Miniconda2-latest-MacOSX-x86_64.sh > miniconda.sh
    $ bash ./miniconda.sh -b -f -p $(pwd)/conda # You can install it wherever you like
    $ export PATH=$(pwd)/conda/bin:$PATH

## Build GRASS into the current environment

### Install GRASS dependencies

It's probably best to build GRASS within a new environment. This will
ensure that they dependencies are what they should be and won't mess
with your current Python distribution.

    $ conda create -n grass python=2.7
    $ source activate grass

Install the dependencies. Note that the `default` channel comes
before `conda-forge`. This is important.

    $ conda install --yes --file=requirements.txt -c defaults -c conda-forge

### Get the GRASS source and compile

    $ curl -O https://grass.osgeo.org/grass72/source/grass-7.2.0.tar.gz
    $ tar xvfz grass-7.2.0.tar.gz

### Apply patches for Anaconda build on Mac

The following patches are necessary to get GRASS to build with
Anaconda on a Mac.
*  `platform.make.in.patch`: Add Mac-specific compile and link options
   to use `rpath` with dynamic libraries.
*  `rules.make.patch`: Run commands with `LD_RUN_PATH` instead of
   `DYLD_LIBRARY_PATH`. This is probably only necessary when dynamically
   loading libraries using `load_library` from the Python module
   `grass.lib.ctypes_loader`
*  `loader.py.patch`: On Mac, additionally use `LD_RUN_PATH` for
   folders to check for libraries to load.

Almost certainly these patches will break things on non-Mac non-Anaconda
builds.

To build GRASS, apply the patches, configure, and build.

    $ patch -p0 < platform.make.in.patch
    $ patch -p0 < loader.py.patch
    $ patch -p0 < rules.make.patch
    $ cd grass-7.2.0
    $ bash ../configure.sh
    $ make -j4 GDAL_DYNAMIC=

## Create an Anaconda package for GRASS

This will build an Anaconda package for GRASS.

    $ conda install conda-build
    $ cd recipe
    $ conda build . -c defaults -c conda-forge
