#!/bin/bash
set -e 

#set env with first user's identity
set_env() {
    echo "${INFO} ----> Setting up env with $user identity"
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/$user@org1.example.com/msp
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
    export CORE_PEER_ADDRESS=localhost:7051
    export TARGET_TLS_OPTIONS=(-o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt")
    echo "${DONE} Done ::: Setting up env"
    echo
}


create_asset() {
    set_env
    echo "${INFO} ----> Creating asset1"
    peer chaincode invoke "${TARGET_TLS_OPTIONS[@]}" -C mychannel -n abac -c '{"function":"CreateAsset","Args":["Asset1","blue","20","100"]}' | jq
    echo "${DONE} ::: Creating asset1"
    echo
}

query_asset() {
    echo "${INFO} ----> querying asset1"
    peer chaincode query -C mychannel -n abac -c '{"function":"ReadAsset","Args":["Asset1"]}' | jq
    echo "${DONE} ::: Creating asset1"
    echo
}