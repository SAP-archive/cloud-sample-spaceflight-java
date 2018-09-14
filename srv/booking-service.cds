using {
    teched.flight.trip as flight,
    teched.space.trip  as space
} from '../db';

service BookingService {

    // ---------------------------------------------------------------------------------------------------------------------
    // Fill our existing CustomerName and EmailAddress fields
    // from the new .Customer association
    // ---------------------------------------------------------------------------------------------------------------------
    entity Bookings    as projection on flight.Bookings {
        *
        , Customer.Name  as CustomerName,
          Customer.Email as EmailAddress
    };

    // ---------------------------------------------------------------------------------------------------------------------
    // Add projections on Customers
    // ---------------------------------------------------------------------------------------------------------------------
    entity Customers as projection on flight.Customers;
    entity CustomersRemote as projection on flight.CustomersRemote;


    entity Itineraries as projection on flight.Itineraries;

    @readonly entity EarthRoutes   as projection on flight.EarthRoutes;
    @readonly entity Airports      as projection on flight.Airports;
    @readonly entity Airlines      as projection on flight.Airlines;
    @readonly entity AircraftCodes as projection on flight.AircraftCodes;

    @readonly entity SpaceRoutes as projection on space.SpaceRoutes;
    @readonly entity Spaceports  as projection on space.Spaceports;
    @readonly entity Spacelines  as projection on space.SpaceFlightCompanies;
    @readonly entity Planets     as projection on space.AstronomicalBodies;

}
