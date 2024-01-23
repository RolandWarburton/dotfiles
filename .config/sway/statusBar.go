package main

import (
	"errors"
	"fmt"
	"os"
	"os/exec"
	"strings"
	"time"
)

type NetworkState struct {
	Connected bool   `json:"state"`
	Device    string `json:"device"`
}

func getActiveWifiConnection(networkState *NetworkState) error {
	connections, err := getWifiDevices()
	found := false
	if err != nil {
		return err
	}
	for i := 0; i < len(connections); i += 1 {
		if connections[i].Connected {
			network := connections[i]
			networkState.Connected = network.Connected
			networkState.Device = network.Device
			found = true
		}
	}
	if found {
		return nil
	} else {
		return errors.New("no connected network was found")
	}
}

func getWifiDevices() ([]NetworkState, error) {
	// get the devices
	cmd := exec.Command("nmcli", "-f", "GENERAL.state,GENERAL.device", "device", "show")
	output, err := cmd.Output()
	if err != nil {
		fmt.Println("Error:", err)
		return nil, err
	}

	lines := strings.Split(string(output), "\n")
	var networks []NetworkState
	for i := 0; i < len(lines)-1; i += 2 {
		var network NetworkState
		stateLine := lines[i]
		deviceLine := lines[i+1]
		if len(stateLine) == 0 || len(deviceLine) == 0 {
			continue
		}

		// STATE
		if stateLine[8:11] == "STA" {
			state := strings.TrimSpace(strings.Split(stateLine, "GENERAL.STATE:")[1])
			network.Connected = strings.Contains(state, "(connected)")
		}

		// DEVICE
		if deviceLine[8:11] == "DEV" {
			device := strings.TrimSpace(strings.Split(deviceLine, "GENERAL.DEVICE:")[1])
			network.Device = device
		}
		networks = append(networks, network)
	}

	return networks, nil
}

func pollActiveWifiDevice(timeout time.Duration, networkState *NetworkState) {
	for {
		getActiveWifiConnection(networkState)
		time.Sleep(timeout)
	}
}

func printStatus(networkState *NetworkState) {
	for {
		temp := time.Now()
		currentTime := temp.Format("2006-01-02 03:04:05 PM")

		battery, err := readBatteryCapacity()
		if err != nil {
			battery = 0
		}

		wifi := ""
		if networkState.Device != "" {
			wifi = fmt.Sprintf("%s UP | ", networkState.Device)
		} else {
			wifi = "WIFI DOWN | "
		}

		result := ""
		if os.Getenv("STATUS_SHOW_WIFI") != "" {
			result = result + wifi
		}

		if os.Getenv("STATUS_SHOW_BATTERY") != "" {
			result = result + fmt.Sprintf("B %d%% | ", battery)
		}

		result = result + currentTime

		fmt.Println(result)

		// Wait for 1 second before printing the next status
		time.Sleep(1 * time.Second)
	}
}

func main() {
	// on occasion check the wifi
	var networkState NetworkState
	go pollActiveWifiDevice(10*time.Second, &networkState)

	go printStatus(&networkState)
	select {}
}

func printBattery() {
	batteryCapacity, err := readBatteryCapacity()
	if err != nil {
		fmt.Println("Error reading battery capacity:", err)
	} else {
		fmt.Printf("B %d%% | %s\n", batteryCapacity, time.Now().Format("2006-01-02 03:04:05 PM"))
	}
}

func readBatteryCapacity() (int, error) {
	batteryFile, err := os.Open("/sys/class/power_supply/BAT0/capacity")
	if err != nil {
		return 0, err
	}
	defer batteryFile.Close()

	var batteryCapacity int
	_, err = fmt.Fscanf(batteryFile, "%d", &batteryCapacity)
	if err != nil {
		return 0, err
	}

	return batteryCapacity, nil
}

func printTime() {
	fmt.Println(time.Now().Format("2006-01-02 03:04:05 PM"))
}
