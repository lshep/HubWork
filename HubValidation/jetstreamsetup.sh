sudo apt-get install subversion
sudo apt-get install libxml2-dev
sudo apt-get install libharfbuzz-dev libfribidi-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev  libmagick++-dev libcairo2-dev libgsl-dev
sudo apt-get install libfftw3-dev libgdal-dev libudunits2-dev
mkdir R-Install R-Install/src R-Install/bin
cd R-Install/src
svn checkout https://svn.r-project.org/R/branches/R-4-5-branch
R-4-5-branch/tools/rsync-recommended
cd ../bin
mkdir R-4-5-branch
cd R-4-5-branch
../../src/R-4-5-branch/configure --enable-R-shlib && make -j
cd ../../..
vi .bash_aliases
    alias R='/home/exouser/R-Install/bin/R-4-5-branch/bin/R'
    alias Rscript='/home/exouser/R-Install/bin/R-4-5-branch/bin/Rscript'

## Preinstall heavy used Bioc class packages to make things easier?? 
