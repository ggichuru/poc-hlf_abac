#!/bin/bash
set -e 


INFO="ℹ️ "
IDEA="💡"
DONE="✅"
ERR="❌"
NOT_FOUND="❗"

cd ../test-network

# import create user simulation
source ../scripts/simulate/create_user.sh

#simulations
createUser1() {
    user="userA"
    password=$user"pw"
    userType="client"

    register_user
    enroll_user

    echo
    echo "${DONE} Done :: Registering and Enrolling $user."
}

createUser2() {
    user="userB"
    password=$user"pw"
    userType="provider"

    register_user
    enroll_user2

    echo 
    echo "${DONE} Done :: Registering and Enrolling $user."
}

# asset simulations
source ../scripts/simulate/create_asset.sh

createAsset() {
    user="userA"

    set_env

    create_asset
    query_asset
}

# # user.create simulations
setup_env
# createUser1
# createUser2

# asset.create simulations
createAsset