# eth-dev

(Hacking together a containerized environment for Ethereum development with
Truffle using Parity)

## Overview

This repository is currently a WIP attempt to get a sane (to me?) Ethereum dev
environment up and running inside docker-compose.

Dev tools include:
 - [truffle](https://github.com/ConsenSys/truffle) to build/deploy contracts
 - [testrpc](https://github.com/ethereumjs/testrpc) to run a "dev" blockchain
 - [parity](https://ethcore.io/parity.html) (against Ropsten) for live testing

## Dependencies

 - Requires [Docker](https://www.docker.com/).
   (tested version 1.13.0-rc2, build 1f9b3ef)


## Getting Started


1. Clone this repository somewhere to be your eth-dev home directory (`$ETH`)

        git clone https://github.com/gnidan/eth-dev.git ~/src/eth

   (for instance)

1. Activate shell environment

        source ~/src/eth/bin/activate.sh

1. Start Docker containers

        docker-compose up -d

1. Create Docker volume for Ropsten Parity Account Info (for convenience)

        docker volume create --name=ropsten

1. Add `parity-ropsten.ethereum` to your /etc/hosts file, pointing locally or
   at your docker-machine

1. Visit `http://parity-ropsten.ethereum/` in your browser.

1. Run `parity-ropsten signer new-token` in your active env shell.

1. (In case anything stops working, I find that restarting docker-compose from
   scratch seems to help:)

        docker-compose down
        docker-compose up -d


## What Else?

- Dapps should live in separate directories in `$ETH/dapps` for `truffle` to
  behave as expected

- `truffle serve` configuration could use some love and might not work right.

- This env works by setting alises - if necessary, you can do `\truffle`, etc.

- I have no idea if configuring Parity behind an nginx proxy is wildly unsafe,
  hence why it's only set up to do Ropsten right now.

  At the very least, though, I will say that Parity tries very hard to prevent
  you from configuring it this way.
