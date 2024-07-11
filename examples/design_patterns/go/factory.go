package main

import "fmt"

// Constants defining vehicle types
var (
	VTYPE_SUV      string = "suv"
	VTYPE_COMPACT  string = "compact"
	VTYPE_SUPERCAR string = "supercar"
)

// Array containing all vehicle types
var VTYPES = [3]string{VTYPE_SUV, VTYPE_COMPACT, VTYPE_SUPERCAR}

// Vehicle interface represents common methods for all vehicles
type Vehicle interface {
	getInfo() string
	getCost(days int64) int64
}

// VehicleCompact represents a compact vehicle
type VehicleCompact struct{}

// getInfo returns information about the compact vehicle
func (vc VehicleCompact) getInfo() string {
	var info string = "Compact info."
	return info
}

// getCost calculates the cost of renting the compact vehicle for a given number of days
func (vc VehicleCompact) getCost(days int64) int64 {
	var cost int64 = days * 20
	return cost
}

// VehicleSuv represents an SUV vehicle
type VehicleSuv struct{}

// getInfo returns information about the SUV vehicle
func (vs VehicleSuv) getInfo() string {
	var info string = "SUV info."
	return info
}

// getCost calculates the cost of renting the SUV vehicle for a given number of days
func (vs VehicleSuv) getCost(days int64) int64 {
	var cost int64 = days * 50
	return cost
}

// VehicleSupercar represents a supercar vehicle
type VehicleSupercar struct{}

// getInfo returns information about the supercar vehicle
func (vsc VehicleSupercar) getInfo() string {
	var info string = "Supercar info"
	return info
}

// getCost calculates the cost of renting the supercar vehicle for a given number of days
func (vsc VehicleSupercar) getCost(days int64) int64 {
	var cost int64 = days * 100
	return cost
}

// VehicleFactory represents a factory for creating vehicles
type VehicleFactory struct{}

// getVehicle returns a vehicle of the specified type
func (vf VehicleFactory) getVehicle(vtype string) Vehicle {
	switch vtype {
	case VTYPE_COMPACT:
		return VehicleCompact{}
	case VTYPE_SUV:
		return VehicleSuv{}
	case VTYPE_SUPERCAR:
		return VehicleSupercar{}
	default:
		return nil
	}
}

func main() {
	var vehicleFactory = VehicleFactory{}

	for _, vt := range VTYPES {
		var vehicle = vehicleFactory.getVehicle(vt)
		fmt.Printf("Getting info for vehicle type %s\n", vt)
		fmt.Printf("%s\n", vehicle.getInfo())
		fmt.Printf("Rental cost for 5 days: %d\n", vehicle.getCost(5))
	}
}
