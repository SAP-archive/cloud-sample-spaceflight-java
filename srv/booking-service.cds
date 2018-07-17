using teched.flight.trip as flight from '../db/space-model';
using teched.space.trip as space from '../db/space-model';
using API_BUSINESS_PARTNER as bp from './external/csn/API_BUSINESS_PARTNER';


service BookingService {

  @cds.persistence.skip
  @readonly entity Customers as projection on bp.A_BusinessPartnerType {
    BusinessPartner as ID,
    BusinessPartnerFullName as Name,
    to_BusinessPartnerAddress.to_EmailAddress.EmailAddress as Email
  };

  extend entity flight.Bookings {
    // actually: Association to Customers
    Customer: Customers.ID;
  };

  entity Bookings as projection on flight.Bookings;

  @readonly entity EarthItineraries as projection on flight.EarthItineraries;
  @readonly entity EarthRoutes as projection on flight.EarthRoutes;
  @readonly entity Airlines as projection on flight.Airlines;
  @readonly entity Airports as projection on flight.Airports;

  @readonly entity SpaceItineraries as projection on space.SpaceItineraries;
  @readonly entity SpaceRoutes as projection on space.SpaceRoutes;
  @readonly entity Spaceports as projection on space.Spaceports;
  @readonly entity Spacelines as projection on space.SpaceFlightCompanies;
  @readonly entity Planets as projection on space.AstronomicalBodies;

}

