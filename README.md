# docker-eth-dev

[![Join the chat at https://gitter.im/gnidan/docker-eth-dev](https://badges.gitter.im/gnidan/docker-eth-dev.svg)](https://gitter.im/gnidan/docker-eth-dev?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Multi-container development environment for building dapps on test chains

## Background / Goals

I'm trying to find a suitable solution to the problem of having to run switch
between running Ethereum nodes and running dapps. Most of the programs all use
the same few ports and don't work together quite so well out of the box.

Docker Compose seems like a reasonable solution - by setting up a virtual
network of containers for individual services, and wrapping it behind a web
proxy, it should remove a lot of the overhead of process and dependency
management.

This project also aims to create a collection of custom wrapper binaries around
the supported services, to maintain the interface of local development while
everything runs virtualized and separated from localhost.


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
 - May require [Docker Compose](https://docs.docker.com/compose/install/)
   also, depending on your Docker installation.


## Getting Started


1. Clone this repository somewhere to be your docker-eth-dev home directory (`$ETH`)
   ```sh
   git clone https://github.com/gnidan/docker-eth-dev.git <dir>
   ```
   This directory will contain the contents of this repository:
    - containers configuration
    - wrapper binaries
    - `dapps` top-level directory
        - example dapp (the `truffle init` result, reconfigured)
    - this README

1. Activate shell environment
   ```sh
   source <dir>/bin/activate.sh
   ```
   This aliases all the wrapper binaries so they're available for us in the
   shell.

1. Create Docker volume for Ropsten Parity
   ```sh
   docker volume create --name=parity-testnet-data
   ```
   This creates a persistent volume so that the Ropsten account information/
   chain data does not get lost when the containers are stopped.

1. Start Docker containers
   ```sh
   docker-compose up -d
   ```
   This runs nginx, testrpc, and parity-testnet inside containers. Port 80
   will be opened on localhost for nginx's proxy.

1. Add `parity-testnet.ethereum` to your /etc/hosts file, pointing locally or
   at your docker-machine

   This is so that nginx may recognize the resource you are trying to reach.

1. Visit `http://parity-testnet.ethereum/` in your browser.

1. Run `parity-testnet signer new-token` in your active env shell.

   In case Parity Wallet needs to authenticate with the running parity-testnet
   container.

1. Note: In case anything stops working, I find that restarting docker-compose from
   scratch seems to help:
   ```sh
   docker-compose down
   docker-compose up -d
   ```


## What Else?

- Dapps should live in separate directories in `$ETH/dapps` for `truffle` to
  behave as expected

- `truffle serve` configuration could use some love and might not work right.

- This env works by setting alises - if necessary, you can do `\truffle`, etc.

- This opens port 80 locally. That's currently hardcoded in. I'm looking for
  ways around this, or to make it easier to deal with.

- I have no idea if configuring Parity behind an nginx proxy is wildly unsafe,
  hence why it's only set up to do Ropsten right now.

  At the very least, though, I will say that Parity tries very hard to prevent
  you from configuring it this way.
