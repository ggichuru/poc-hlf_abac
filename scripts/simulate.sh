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

user=${1:-"userA"}
password=$user"pw"
userType="client"

#simulations
createUser() {
    register_user
    enroll_user

    echo
    echo "${DONE} Done :: Registering and Enrolling $user."

    set_asset_env
}

createUser2() {
    user="creator02"
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
    user="creator01"

    create_asset
    query_asset
}

# # user.create simulations
# setup_env
# create_creator1
createUser
# createUser2

# asset.create simulations
# createAsset