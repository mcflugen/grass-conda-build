#! /bin/bash

# NOTE: This script must be run from the top-level folder
# of the grass-conda-build repository.

# Set the location of your Anaconda installation
ANACONDA_PREFIX=$(pwd)/conda

# Set up environment
export PATH=$ANACONDA_PREFIX/bin:/usr/bin:/bin:/usr/sbin:/etc:/usr/lib

# Create a new Python environment to install GRASS into
conda create --yes -n grass python=2.7
source activate grass
conda install --yes --file=requirements.txt -c noaa-orr-erd -c defaults -c conda-forge

# Get the GRASS source code.
# svn checkout https://svn.osgeo.org/grass/grass/branches/releasebranch_7_2 grass-7.2.2
curl -O https://grass.osgeo.org/grass72/source/grass-7.2.2RC1.tar.gz
tar xfz grass-7.2.2RC1.tar.gz && cd grass-7.2.2RC1

# Apply patches.
PATCHES="\
  platform.make.in.patch \
  loader.py.patch \
  rules.make.patch \
  aclocal.m4.patch \
  install.make.patch \
  configure.patch"
for p in $PATCHES; do patch -p1 < ../recipe/$p; done

# Set environment for GRASS build.
export PREFIX=$(python -c "import sys; print sys.prefix")
export GRASS_PYTHON=$(which pythonw)
export PATH=$PREFIX/bin:/usr/bin:/bin:/usr/sbin:/etc:/usr/lib

# Configure, build, and install GRASS
bash ../configure.sh && make -j4 GDAL_DYNAMIC= && make -j4 install
