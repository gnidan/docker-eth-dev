FROM node:6.9.1
MAINTAINER gnidan

# jessie : python 2.7
# python 2.7 only is supported by node-gyp (needed by truffle)
RUN \
    apt-get update \
    && \
    apt-get install -qy  --no-install-recommends \
        build-essential \
        git \
    && \
    rm -rf /var/lib/apt/lists/*

RUN \
    git clone https://github.com/oraclize/ethereum-bridge.git \
        /var/oraclize-bridge

WORKDIR /var/oraclize-bridge

RUN \
    npm install

ENTRYPOINT \
    echo "Creating SENTINEL" \
        && touch /var/oraclize-bridge/config/instance/SENTINEL \
    && echo "Starting Oraclize Bridge" \
        && node bridge -H testrpc:8545 -a 9
