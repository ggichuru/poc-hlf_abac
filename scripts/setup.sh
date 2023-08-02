#!/bin/bash

setup-network() {
    # install fabric binaries, docker and fabric_samples
    

    ./network.sh down

    ./network.sh up createChannel -ca 
}