# This code showcases the usage of abstract base classes (ABCs) and the factory design pattern in a vehicle rental system.
# It defines abstract vehicle classes representing different types of vehicles (compact cars, SUVs, and supercars),
# concrete implementations for each vehicle type, and a factory class responsible for creating instances of vehicle types.


from abc import ABC, abstractmethod


# Constants defining vehicle types
VTYPE_SUV = "suv"
VTYPE_COMPACT = "compact"
VTYPE_SUPERCAR = "supercar"

# Tuple containing all vehicle types
VTYPES = (VTYPE_SUV, VTYPE_COMPACT, VTYPE_SUPERCAR)


class Vehicle(ABC):
    """
    Abstract base class representing a vehicle.
    """

    @abstractmethod
    def get_info(self):
        """
        Get information about the vehicle.

        :return: Information about the vehicle.
        """
        pass

    @abstractmethod
    def get_models(self):
        """
        Get a list of models for the vehicle type.

        :return: List of vehicle models.
        """
        pass

    @abstractmethod
    def get_cost(self, days):
        """
        Calculate the rental cost for the vehicle for a given number of days.

        :param days: Number of days for rental.
        :return: Rental cost.
        """
        pass


class VehicleCompact(Vehicle):
    """
    Class representing a compact car.
    """

    def get_info(self):
        """
        Get information about the compact car.

        :return: Information about the compact car.
        """
        info = "Cars with an interior volume index of 100–109 cu ft (2.8–3.1 m3)."
        return info

    def get_models(self):
        """
        Get a list of compact car models.

        :return: List of compact car models.
        """
        models = ["Toyota Corolla", "Honda Civic", "Volkswagen Golf", "Ford Focus", "Mazda3"]
        return models

    def get_cost(self, days):
        """
        Calculate the rental cost for the compact car for a given number of days.

        :param days: Number of days for rental.
        :return: Rental cost.
        """
        return days * 30
    

class VehicleSuv(Vehicle):
    
    def get_info(self):
        """
        Get information about the SUV.

        :return: Information about the SUV.
        """
        info = "A sport utility vehicle (SUV) is a car classification that combines elements of road-going passenger cars with features from off-road vehicles, such as raised ground clearance and four-wheel drive."
        return info

    def get_models(self):
        """
        Get a list of SUV models.

        :return: List of SUV models.
        """
        models = ['Toyota RAV4', 'Honda CR-V', 'Ford Explorer', 'Nissan Rogue', 'Chevrolet Tahoe']
        return models

    def get_cost(self, days):
        """
        Calculate the rental cost for the SUV for a given number of days.

        :param days: Number of days for rental.
        :return: Rental cost.
        """
        return days * 50
    

class VehicleSupercar(Vehicle):
    """
    Class representing a supercar.
    """

    def get_info(self):
        """
        Get information about the supercar.

        :return: Information about the supercar.
        """
        info = "A type of automobile generally described as a street-legal, luxury superlative performance sports car, both in terms of power, speed, and handling."
        return info

    def get_models(self):
        """
        Get a list of supercar models.

        :return: List of supercar models.
        """
        models = ["Ferrari LaFerrari", "Lamborghini Aventador", "McLaren P1", "Bugatti Chiron", "Porsche 911 Turbo S"]
        return models

    def get_cost(self, days):
        """
        Calculate the rental cost for the supercar for a given number of days.

        :param days: Number of days for rental.
        :return: Rental cost.
        """
        return days * 100
    
    

class VehicleFactory:
    """
    Factory class responsible for creating instances of vehicle types.
    """

    @staticmethod
    def get_vehicle(type):
        """
        Create and return an instance of the specified vehicle type.

        :param type: Type of vehicle to create.
        :return: Instance of the specified vehicle type.
        :raises ValueError: If an invalid vehicle type is provided.
        """
        if type == VTYPE_SUV:
            return VehicleSuv()
        elif type == VTYPE_COMPACT:
            return VehicleCompact()
        elif type == VTYPE_SUPERCAR:
            return VehicleSupercar()
        else:
            raise ValueError(f'{type} is not a valid vehicle type! Valid types are: {", ".join(VTYPES)}')


# Example for how the code could be run
if __name__ == "__main__":
    vehicle_factory = VehicleFactory()

    # Iterating over all vehicle types to acquire information for each
    for vehicle_type in VTYPES:

        vehicle_compact = vehicle_factory.get_vehicle(vehicle_type)
        print(f'Getting info for vehicle type {vehicle_type}')
        print(vehicle_compact.get_info())
        print(f'Rental cost for 5 days: {vehicle_compact.get_cost(5)}')
