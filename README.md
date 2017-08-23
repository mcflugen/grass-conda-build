Anaconda distribution of GRASS
==============================

Get a minimal anaconda installation
-----------------------------------

    $ curl https://repo.continuum.io/miniconda/Miniconda2-latest-MacOSX-x86_64.sh > miniconda.sh # You can substitute Linux of MacOSX
    $ bash ./miniconda.sh -b -f -p $(pwd)/conda # You can install it wherever you like
    $ export PATH=$(pwd)/conda/bin:$PATH

Install GRASS dependencies
--------------------------

    $ conda install --yes --file=requirements.txt -c defaults -c conda-forge

Get the GRASS source and compile
--------------------------------

    $ curl -O https://grass.osgeo.org/grass72/source/grass-7.2.0.tar.gz
    $ tar xvfz grass-7.2.0.tar.gz

Apply patches for Anaconda build on Mac
---------------------------------------

    $ patch -p0 < platform.make.in.patch
    $ patch -p0 < loader.py.patch
    $ patch -p0 < rules.make.patch
    $ cd grass-7.2.0
    $ bash ../configure.sh
    $ make -j4 GDAL_DYNAMIC=
