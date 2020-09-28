FROM kwhadocker/data-env:v5

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

# Install requirements
# Will also run buildreqs/marvin/requirements.txt since
# the insurance requirements file will point to marvin file
# This layer costs 1.28GB - not sure how to fix this issue.
# explicitly install numpy first?
# note that some libraries are on older versions than data-env imagee
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
