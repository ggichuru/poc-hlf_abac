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

    echo
    echo "${DONE} Done Installing HLF"
    echo 
    
}

  
setup_testnet () {

    # Check if the test-network folder exists and delete it
    if [ ! -d "test-network/" ]; then
        echo
        echo "${INFO} -> test-network notFound."
        echo "${INFO} -> Setting up testnet folder"
        echo

        # get the test nework folder from fabric-samples repo
        cp -R fabric-samples/test-network ./test-network
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

install_fabric
setup_testnet