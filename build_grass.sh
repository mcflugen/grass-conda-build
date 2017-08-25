#! /bin/bash

ANACONDA_PREFIX=$(pwd)/conda
export PATH=$ANACONDA_PREFIX/bin:/usr/bin:/bin:/usr/sbin:/etc:/usr/lib

svn checkout https://svn.osgeo.org/grass/grass/branches/releasebranch_7_2 grass-7.2.2
# curl -O https://grass.osgeo.org/grass72/source/grass-7.2.0.tar.gz
# tar xvfz grass-7.2.0.tar.gz

conda create -n grass python=2.7
source activate grass
conda install --yes --file=requirements.txt -c noaa-orr-erd -c defaults -c conda-forge

patch -p0 < recipe/platform.make.in.patch
patch -p0 < recipe/loader.py.patch
patch -p0 < recipe/rules.make.patch
patch -p0 < recipe/aclocal.m4.patch
patch -p0 < recipe/install.make.patch
patch -p0 < recipe/configure.patch

cd grass-7.2.2
bash ../configure.sh
make -j4 GDAL_DYNAMIC=
make -j4 install
