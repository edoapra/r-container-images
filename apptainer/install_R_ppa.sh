#!/bin/bash
set -e


CRAN_LINUX_VERSION=cran40
LANG=${LANG:-en_US.UTF-8}
LC_ALL=${LC_ALL:-en_US.UTF-8}
DEBIAN_FRONTEND=noninteractive

# Set up and install R
R_HOME=${R_HOME:-/usr/lib/R}

#R_VERSION=${R_VERSION}

apt-get update
apt-get install -y tzdata
#apt-get install -y locales
#locale-gen en_US.UTF-8
#dpkg-reconfigure locales
apt-get -y install --no-install-recommends \
      ca-certificates \
      less \
      libopenblas-base \
      locales \
      vim-tiny \
      wget \
      dirmngr \
      lsb-release \
      make \
      gcc g++ gfortran pkg-config\
      libpcre2-dev liblzma-dev libbz2-1.0 libz3-dev libzstd-dev  zsh \
      gpg \
      gpg-agent

echo "deb http://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-${CRAN_LINUX_VERSION}/" >> /etc/apt/sources.list

#gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
#apt-key adv --fetch-keys "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xe298a3a825c0d65dfd57cbb651716619e084dab9"
#wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc |  tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
#gpg -a --export E298A3A825C0D65DFD57CBB651716619E084DAB9 | apt-key add -
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc

# Wildcard * at end of version will grab (latest) patch of requested version
apt-get update && apt-get -y install --no-install-recommends r-base #-dev=${R_VERSION}* 
echo "search Rscript" `apt-cache search Rscript`
echo "where is Rscript" `dpkg-query -S Rscript || true `

rm -rf /var/lib/apt/lists/*

## Add PPAs: NOTE this will mean that installing binary R packages won't be version stable.
##
## These are required at least for bionic-based images since 3.4 r binaries are

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen en_US.utf8
/usr/sbin/update-locale LANG=${LANG}
exit 0
Rscript -e "install.packages(c('littler', 'docopt'))"

## By default R_LIBS_SITE is unset, and defaults to this, so this is where `littler` will be.
## We set it here for symlinks, but don't make the env var persist (since it's already the default)
R_LIBS_SITE=/usr/local/lib/R/site-library
ln -s ${R_LIBS_SITE}/littler/examples/install.r /usr/local/bin/install.r
ln -s ${R_LIBS_SITE}/littler/examples/install2.r /usr/local/bin/install2.r
ln -s ${R_LIBS_SITE}/littler/examples/installGithub.r /usr/local/bin/installGithub.r
ln -s ${R_LIBS_SITE}/littler/bin/r /usr/local/bin/r
