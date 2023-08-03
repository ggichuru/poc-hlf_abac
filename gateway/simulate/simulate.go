package simulate

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"time"

	"github.com/hyperledger/fabric-gateway/pkg/client"
)

/** SMART CONTRACT METHODS*/

func CreateAsset(contract *client.Contract, assetID string) uint64 {
	fmt.Printf("\n--> Submit transaction: CreateAsset, %s owned by Sam with appraised value 100\n", assetID)

	_, commit, err := contract.SubmitAsync("CreateAsset", client.WithArguments(assetID, "blue", "10", "100"))
	if err != nil {
		panic(fmt.Errorf("failed to submit transaction: %w", err))
	}

	status, err := commit.Status()
	if err != nil {
		panic(fmt.Errorf("failed to get transaction commit status: %w", err))
	}

	if !status.Successful {
		panic(fmt.Errorf("failed to commit transaction with status code %v", status.Code))
	}

	fmt.Println("\n*** CreateAsset committed successfully")

	return status.BlockNumber
}

func UpdateAsset(contract *client.Contract, assetID string) {
	fmt.Printf("\n--> Submit transaction: UpdateAsset, %s update appraised value to 200\n", assetID)

	_, err := contract.SubmitTransaction("UpdateAsset", assetID, "blue", "10", "200")
	if err != nil {
		panic(fmt.Errorf("failed to submit transaction: %w", err))
	}

	fmt.Println("\n*** UpdateAsset committed successfully")
}

func TransferAsset(contract *client.Contract, assetID string) {
	fmt.Printf("\n--> Submit transaction: TransferAsset, %s to Mary\n", assetID)

	_, err := contract.SubmitTransaction("TransferAsset", assetID, "Mary")
	if err != nil {
		panic(fmt.Errorf("failed to submit transaction: %w", err))
	}

	fmt.Println("\n*** TransferAsset committed successfully")
}

func DeleteAsset(contract *client.Contract, assetID string) {
	fmt.Printf("\n--> Submit transaction: DeleteAsset, %s\n", assetID)

	_, err := contract.SubmitTransaction("DeleteAsset", assetID)
	if err != nil {
		panic(fmt.Errorf("failed to submit transaction: %w", err))
	}

	fmt.Println("\n*** DeleteAsset committed successfully")
}

func GetAllAssets(contract *client.Contract) {
	fmt.Println("\n--> Submit transaction: Get all assets ")

	assets, err := contract.EvaluateTransaction("GetAllAssets")
	if err != nil {
		panic(fmt.Errorf("failed to submit transaction: %w", err))
	}
	result := formatJSON(assets)
	fmt.Println(result)
	fmt.Println("\n*** GetAllAssets evaluated successfully")
}

/** CHAINCODE EVENTS FUNCTIONS */
func StartChaincodeEventListening(ctx context.Context, network *client.Network, ccname string) {
	fmt.Println("\n*** Start chaincode event listening")

	events, err := network.ChaincodeEvents(ctx, ccname)
	if err != nil {
		panic(fmt.Errorf("failed to start chaincode event listening: %w", err))
	}

	go func() {
		for event := range events {
			asset := formatJSON(event.Payload)
			fmt.Printf("\n<-- Chaincode event received: %s - %s\n", event.EventName, asset)
		}
	}()
}

func ReplayChaincodeEvents(ctx context.Context, network *client.Network, startBlock uint64, ccname string) {
	fmt.Println("\n*** Start chaincode event replay")

	events, err := network.ChaincodeEvents(ctx, ccname, client.WithStartBlock(startBlock))
	if err != nil {
		panic(fmt.Errorf("failed to start chaincode event listening: %w", err))
	}

	for {
		select {
		case <-time.After(10 * time.Second):
			panic(errors.New("timeout waiting for event replay"))

		case event := <-events:
			asset := formatJSON(event.Payload)
			fmt.Printf("\n<-- Chaincode event replayed: %s - %s\n", event.EventName, asset)

			if event.EventName == "DeleteAsset" {
				// Reached the last submitted transaction so return to stop listening for events
				return
			}
		}
	}
}

/** HELPERS */
func formatJSON(data []byte) string {
	var result bytes.Buffer
	if err := json.Indent(&result, data, "", "  "); err != nil {
		panic(fmt.Errorf("failed to parse JSON: %w", err))
	}
	return result.String()
}
