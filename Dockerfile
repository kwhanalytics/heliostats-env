FROM 657285219065.dkr.ecr.us-west-2.amazonaws.com/kwhadocker/data-env:v14-arm

# Move to root
WORKDIR /root/

# Copy requirement files (marvin requirements will already have been installed
#   in the data-env image which this inherits from)
COPY heliostats-requirements.txt buildreqs/heliostats-requirements.txt
COPY package.json ./package.json

# Install apache2 (necessary for dev servers running heliostats)
RUN apt-get update && apt-get install -y \
    apache2 \
    apache2-dev \
    libapache2-mod-xsendfile \
    python3.7-dev \
    python-setuptools

# `python` is /usr/bin/python, a symlink. Overwrite old symlink with a new one.
# New one will point to python3.7 so that's the version we'll get when running
# `python`.
# Note: This seems to work locally when connected to a docker container, but not
# in the python commands run below, so they explicitly specify 'python3.7'.
RUN ln -f /usr/bin/python3.7  /usr/bin/python

# update pip
RUN python3.7 -m pip install pip==21.1.2

# required for arm architecture
RUN ln -f /usr/include/locale.h /usr/include/xlocale.h

# Required to be installed first in order to build pandas
RUN python3.7 -m pip install cython numpy==1.18.4

# Install requirements
RUN pip --no-cache-dir install -r buildreqs/heliostats-requirements.txt


# Do we need to / want to create an ENTRYPOINT HERE?

# Install npm and node
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
# set up NVM_DIR and load nvm
ENV NVM_DIR /root/.nvm
# most recent LTS node version
ENV NODE_VERSION 12.18.3

RUN . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# confirm installation
RUN node -v
RUN npm -v

# Install Javascript dependencies using Node Package Manager:
RUN npm install  #Local install here writes to /root/node_modules

# Run bash on startup
CMD ["/bin/bash"]
