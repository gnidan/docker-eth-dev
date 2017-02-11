FROM node:6.9.1
MAINTAINER gnidan

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
        && node bridge -H testrpc:8545 -a 9 --dev --disable-price
