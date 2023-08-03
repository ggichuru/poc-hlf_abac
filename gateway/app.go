/*
Copyright 2022 IBM All Rights Reserved.

SPDX-License-Identifier: Apache-2.0
*/

package main

import (
	"context"
	"fmt"
	"time"

	"github.com/hyperledger/fabric-gateway/pkg/client"

	"gateway/simulate"
)

const (
	channelName = "mychannel"
	ccname      = "abac"
)

var now = time.Now()

var assetID = fmt.Sprintf("asset%d", now.Unix()*1e3+int64(now.Nanosecond())/1e6)

// var assetID = "asset1691085567931"

func main() {
	clientConnection := newGrpcConnection()
	defer clientConnection.Close()

	id := newIdentity()
	sign := newSign()

	gateway, err := client.Connect(
		id,
		client.WithSign(sign),
		client.WithClientConnection(clientConnection),
		client.WithEvaluateTimeout(5*time.Second),
		client.WithEndorseTimeout(15*time.Second),
		client.WithSubmitTimeout(5*time.Second),
		client.WithCommitStatusTimeout(1*time.Minute),
	)
	if err != nil {
		panic(err)
	}
	defer gateway.Close()

	network := gateway.GetNetwork(channelName)
	contract := network.GetContract(ccname)

	// Context used for event listening
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	// Listen for events emitted by subsequent transactions

	simulate.StartChaincodeEventListening(ctx, network, ccname)

	simulate.CreateAsset(contract, assetID)
	// startBlock := simulate.CreateAsset(contract, assetID)
	// simulate.UpdateAsset(contract, assetID)
	// simulate.TransferAsset(contract, assetID)
	// simulate.DeleteAsset(contract, assetID)
	simulate.GetAllAssets(contract)

	// Replay events from the block containing the first transaction
	// simulate.ReplayChaincodeEvents(ctx, network, startBlock, ccname)
}
