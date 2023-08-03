#!/bin/bash
set -e 

# set env variables for registrations and enrollement
setup_env() {
    echo
    echo "${INFO} ----> setting up environment."
    # setup env
    export PATH=${PWD}/../bin:${PWD}:$PATH
    export FABRIC_CFG_PATH=$PWD/../config/


    # Set the fabric CA client home to the MSP of org1
    export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.example.com/
}

register_user () {
    echo
    echo "${INFO} ----> Registering $user."
    #  register an identity named creator1 with the attribute of abac.creator=true
    fabric-ca-client register --id.name $user --id.secret $password --id.type $userType --id.affiliation org1 --id.attrs 'abac.creator=true:ecert' --tls.certfiles "${PWD}/organizations/fabric-ca/org1/tls-cert.pem"
    echo "${DONE} $user has been registered"
}

enroll_user() {
    echo
    echo "${INFO} ----> Enrolling $user."
    # enroll user
    fabric-ca-client enroll -u https://$user:$password@localhost:7054 --caname ca-org1 -M "${PWD}/organizations/peerOrganizations/org1.example.com/users/$user@org1.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/org1/tls-cert.pem"
    echo "${DONE} $user has been enrolled"
    echo
    echo "${INFO} ----> Copying node config file to $user msp folder."
    # copy NODE Ou configuration file into user msp folder
    cp "${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/org1.example.com/users/$user@org1.example.com/msp/config.yaml"
}

enroll_user2() {
    export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.example.com/
    echo
    echo "${INFO} ----> Enrolling $user (method 2)."
    # enroll user by adding the attribute to the certificate
    fabric-ca-client enroll -u https://$user:$password@localhost:7054 --caname ca-org1 --enrollment.attrs "abac.creator" -M "${PWD}/organizations/peerOrganizations/org1.example.com/users/$user@org1.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/org1/tls-cert.pem"
    echo "${DONE} $user has been enrolled"
    echo
    echo "${INFO} ----> Copying node config file to $user msp folder."
    cp "${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/org1.example.com/users/$user@org1.example.com/msp/config.yaml"

}