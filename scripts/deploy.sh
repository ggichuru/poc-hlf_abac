#!/bin/bash
set -e

INFO="ℹ️ "
IDEA="💡"
DONE="✅"
ERR="❌"
ABOVE="⬆️"
NOT_FOUND="❗"

cc_name="abac"
cc_version=${1:-"1"}
cc_sequence=${2:-"1"}

echo "${INFO} --> switching dir to ../test-network"
cd ../test-network
echo 

setup_env() {

    # Commands required to aid in network interaction
    echo
    echo "${INFO} --> setting up env variabales ENV VARIABLES :"
  
    export PATH=${PWD}/../bin:$PATH
    export FABRIC_CFG_PATH=$PWD/../config/


    # Environment variables for Org1
    # export CORE_PEER_TLS_ENABLED=true
    # export CORE_PEER_LOCALMSPID="Org1MSP"
    # export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
    # export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
    # export CORE_PEER_ADDRESS=localhost:7051

    echo
    echo "${INFO} ---> DEPLOYING CHAINCODE :"
    echo "               -ccn [chaicodeName]        ==      $cc_name"
    echo "               -ccp [chaicodePackage]     ==      ../contracts/$cc_name"
    echo "               -ccp [chaicodeLanguage]    ==      go"
    echo 

}



check_contianer() {
    CNAME=$1
    if [ "$(docker ps -qa -f name=$CNAME)" ]; then
        echo "${INFO} ::: Found container - $CNAME"
        if [ "$(docker ps -q -f name=$CNAME)" ]; then
            echo "${INFO} ::: Stopping running container - $CNAME"
            docker stop $CNAME;
        fi
        echo "${INFO} ::: Removing stopped container - $CNAME"
        docker rm $CNAME;
    fi
}

deploy_ccaas() {
    org1="peer0org1_insurance_ccaas"
    org2="peer0org2_insurance_ccaas"
    
    # stop and remove containers if any
    check_contianer $org1
    check_contianer $org2
    echo

    # Deploy chaincode as a service
    echo "${INFO} --> Deploying chaincode as service"
    ./network.sh deployCCAAS -ccn $cc_name -ccp ../chaincode/abac-asset/  -ccl go -ccv $cc_version -ccs $cc_sequence
}

deploy_cc() {
    # Deploy the chaincode
    echo "${INFO} --> Deploying chaincode"
    ./network.sh deployCC -ccn $cc_name -ccp ../chaincode/abac-asset/  -ccl go -ccv $cc_version -ccs $cc_sequence

}

deploy_chaincode() {
    # get chaincode sequence
    sequence=$(peer lifecycle chaincode queryapproved -C mychannel -n $cc_name --output json | jq -r '.sequence')
    
    if [[ "$sequence" -ge 1 ]]; then
        #increment chaincode version and sequence
        let cc_version=sequence+1
        let cc_sequence=sequence+1
    fi

    # Deploy the chaincode
    deploy_cc

    #deploy Chaincode as a service
    # deploy_ccaas

    if [ $? -ne 0 ]; then
        echo "${ERR} Error Deploying chaincode. ${IDEA} Check logs above ${ABOVE}"
        exit 1
    fi

}

copy_testnet_orgs () {
    if [ -d "../application/test-network" ]; then
        echo "${INFO} Removing test folder"
        echo
        rm -rf ../application/test-network
        wait
    fi
    
    echo "${INFO} Copying Organizations to bcclient"
    echo
        
    cp -R . ../application/test-network
    echo "${DONE} Copying Organizations to bcclient"  
}



deploy_chaincode
# setup_env