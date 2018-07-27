using teched.flight.trip as flight from '../db';
using BookingService from 'spaceflight-model/srv';

// ---------------------------------------------------------------------------------------------------------------------
// Add projections on Customers to BookingService
// ---------------------------------------------------------------------------------------------------------------------
extend service BookingService with {

  entity Customers as projection on flight.Customers;

  @cds.persistence.skip
  entity CustomersRemote as projection on flight.CustomersRemote;
}
