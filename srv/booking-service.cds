using teched.flight.trip as flight from '../db';
using BookingService from 'spaceflight-model/srv';


extend service BookingService with {
  entity Customers as projection on flight.Customers;

  // @cds.persistence.skip
  // @readonly
  // entity Customers as SELECT from bp.A_BusinessPartnerType {
  //   @title: "ID"    BusinessPartner         as ID,
  //   @title: "Name"  BusinessPartnerFullName as Name,
  //   @title: "Email" to_BusinessPartnerAddress.to_EmailAddress.EmailAddress as Email
  // } where Customer != null;
}

service LoadDataService {
  entity Customers as projection on flight.Customers;
  function loadCustomers() returns Integer; // number of customers fetched
}