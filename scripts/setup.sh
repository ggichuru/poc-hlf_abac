#!/bin/bash

INFO="ℹ️ "
IDEA="💡"
DONE="✅"
ERR="❌"
NOT_FOUND="❗"


install_fabric() {
    # install fabric binaries and containers and smaples
    echo "${INFO} Installing Hypeledger Farbric binary files and docker container"
    ./install-fabric.sh d b s
    if [ $? -ne 0 ]; then
        echo "${ERR} Error setting up fabric. ${IDEA} Check logs"
        exit 1
    fi
    
    # mkdir ../_cfg

    echo
    echo "${DONE} Done Installing HLF"
    echo 
    
}

  
setup_testnet () {

    # Check if the test-network folder exists and delete it
    if [ ! -d "../test-network" ]; then
        echo
        echo "${INFO} -> test-network notFound."
        echo "${INFO} -> Setting up testnet folder"
        echo

        # get the test nework folder from fabric-samples repo
        cp -R fabric-samples/test-network ../test-network
        if [ $? -ne 0 ]; then
            echo "${ERR} Error setting up test-network. ${IDEA} Check logs"
            exit 1
        fi

        # Remove fabric-samples folder
        rm -rf fabric-samples

        echo "${DONE} -> Done setting up testnet."
    else
        echo
        echo "${ERR} -> test-network already exists"
    fi

    echo ""
}

start_testnet() {
    echo
    echo "${INFO} --> starting testnetwork with CA enabled"

    cd ../test-network

    echo "${INFO} -> pulling down any fabric network running"
    ./network.sh down


    echo "${INFO} +> ${IDEA} STARTING THE TEST NETWORK ${IDEA} "
    echo "  -> we are creating a channel called 'mychannel' whilst enabling couchDB and Certificate Authorities"

    ./network.sh up createChannel -ca -c mychannel -s couchdb

    echo "${DONE} configuring HLF-Testnet"
    echo ""
}

install_fabric
setup_testnet
start_testnet