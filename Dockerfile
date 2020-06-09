FROM kwhadocker/ubuntu18-postgres11:latest

# Move to root
WORKDIR /root/

# Install Ubuntu packages
# Install GEOS packages needed for basemap
# This layer costs 487MB in total
# Combined apt-get update install lines and added one more cleaning functio
## TODO KE 
# will python-dev, python-tk and python-pip still install python2?
# can we install python3 here?
# why are we installing vim, curl, and git if we're starting with
# ubuntu18???

## Prerequisite: Updating apt-utils
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

# Next: Continuing with the rest of the apt packages
RUN apt-get update && apt-get install -y \
        strace \
        build-essential \
        lsof \
        vim \
        curl \
        git \
        mc \
        sysstat \
        iotop \
        dstat \
        iptraf \
        screen \
        tmux \
        zsh \
        xfsprogs \
        libffi-dev \
        python-dev \
        chromium-chromedriver \
        python-tk \
        python-pip \
        libgeos-c1v5 \
        libgeos-dev && \
    apt-get autoremove -y && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* && \
    mkdir -p buildreqs/requirements

# Copy requirement files
COPY marvin-requirements.txt buildreqs/marvin-requirements.txt
COPY heliostats-requirements.txt buildreqs/heliostats-requirements.txt
COPY package.json ./package.json

# Python 3 setup
# KE TODO do we need this python3 setup or can we just install it
# in the apt-get section up there??

# Following section taken from
# https://github.com/kwhanalytics/postgis-heliostats-py3.5/blob/master/Dockerfile
# We need Python 3.5 because it's the last version that supports Pandas 0.18.
# Python 3.5 is no longer included in the default apt-get repo in Ubuntu 18.04, so we
# add the "Deadsnakes" repo where apt-get can find older Python version:
## KE edit 2020-04-12
# Adding software-properties-common to get add-apt-repository to work
RUN apt-get update && apt-get install -y software-properties-common && apt-get update

RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update

# Install python 3.5 from deadsnakes
RUN apt-get install -y libpq-dev build-essential python3.5 python3.5-dev python3-pip python3.5-venv

# update pip
RUN python3.5 -m pip install pip --upgrade
RUN python3.5 -m pip install wheel

# `python` is /usr/bin/python, a symlink. Delete old symlink, make new one.
# New one will point to python3.5 so that's the version we'll get when running
# `python`.
RUN ln -f /usr/bin/python3.5  /usr/bin/python

RUN python --version


# Install requirements
# Will also run buildreqs/marvin/requirements.txt since
# the insurance requirements file will point to marvin file
# This layer costs 1.28GB - not sure how to fix this issue.
# explicitly install numpy first?
# note that some libraries are on older versions than data-env imagee
RUN pip --no-cache-dir install -r buildreqs/marvin-requirements.txt
RUN pip --no-cache-dir install -r buildreqs/heliostats-requirements.txt

# so - heliostats-requirements.txt has numpy 1.17.__
# and that, in conjunction with pandas 0.18, causes integration tests to break
# for now, I'll manually have numpy to 1.11.0, but we should upgrade both pandas
# and numpy now that we are on py3
RUN pip install numpy==1.11.0

# Do we need to / want to create an ENTRYPOINT HERE?

# Install npm and node
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
# set up NVM_DIR and load nvm
ENV NVM_DIR /root/nvm
ENV NODE_VERSION 4.4.7

RUN . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# confirm nvm installation
RUN nvm --version
# install node
RUN nvm install node

# confirm installation
RUN node -v
RUN npm -v

# Install Javascript dependencies using Node Package Manager:
RUN npm install
RUN npm run build

# Run bash on startup
CMD ["/bin/bash"]