using teched.flight.trip as flight from '../db/space-model';
using teched.space.trip as space from '../db/space-model';

service FlightService {
    entity EarthRoutes   as projection on flight.EarthRoutes;
    entity Airports      as projection on flight.Airports;
    entity Airlines      as projection on flight.Airlines;
    entity AircraftCodes as projection on flight.AircraftCodes;

    entity SpaceRoutes as projection on space.SpaceRoutes;
    entity Spaceports  as projection on space.Spaceports;
    entity Spacelines  as projection on space.SpaceFlightCompanies;
    entity Planets     as projection on space.AstronomicalBodies;
}