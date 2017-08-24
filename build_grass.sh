#! /bin/bash

ANACONDA_PREFIX=$(pwd)/conda
export PATH=$ANACONDA_PREFIX/bin:/usr/bin:/bin:/usr/sbin:/etc:/usr/lib

curl -O https://grass.osgeo.org/grass72/source/grass-7.2.0.tar.gz
tar xvfz grass-7.2.0.tar.gz

conda create --yes -n grass python=2.7
source activate grass
conda install --yes --file=requirements.txt -c noaa-orr-erd -c defaults -c conda-forge

patch -p0 < platform.make.in.patch
patch -p0 < loader.py.patch
patch -p0 < rules.make.patch
patch -p0 < aclocal.m4.patch
patch -p0 < install.make.patch
patch -p0 < configure.patch

cd grass-7.2.0
bash ../configure.sh
make -j4 GDAL_DYNAMIC=
make install
