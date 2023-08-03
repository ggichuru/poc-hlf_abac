# HOW TO

Guides on how to run this project

## Setting up hypeledger fabric (hlf) testnet

1. **The first thing you need to do is to setup the fabric network**

- while in the project root switch to script dir

``` bash
    # change directory to scripts
    cd scripts
```

- run setup script (this scripts helps setup the network and create a channel "mychannel" with couchDb and CA enabled)

```bash
    # setup hlf testnet
    ./setup.sh
```

2. **After setting up the fabric testnet, you can deploy the chaincode to the channel (mychannel)**

```bash
    # deploy chaincode to "mychannel"
    ./deploy.sh
```

3. **Now you can simulate creating a user**

    - To simulate creation of userA, run the simulate script

    ```bash
        # simulate creation of default user [userA]
        ./simulate.sh
    ```

    - To simulate creation of another user, pass the username as an argument

    ```bash
        # simulate creation of custom user 
        ./simulate.sh userB
    ```

The testnetwork should now be completely setup with atleast on user.

---

## Running the go application

To run the gateway application for simulating user activities,

```bash
    # cd into gateway dir from root
    cd gateway

    # run go app
    go run .
```

> **NOTE**: To simulate different smart contract functions, you have to make some edits to the  [app.go](./gateway/app.go) for function calls and [connect.go](./gateway/connect.go) to change the current user interacting with the blockchain network.
