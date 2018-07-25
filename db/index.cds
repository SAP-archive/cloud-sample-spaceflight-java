namespace teched.flight.trip;

using teched.flight.trip   as flight from 'spaceflight-model/db';
using API_BUSINESS_PARTNER as bp     from './external/csn/API_BUSINESS_PARTNER';

entity Customers {
  @title: "ID"       key ID:    bp.A_BusinessPartnerType.BusinessPartner;
  @title: "Name"         Name:  bp.A_BusinessPartnerType.BusinessPartnerFullName;
  @title: "Email"        Email: bp.A_AddressEmailAddressType.EmailAddress;
};

// @cds.persistence.kind(...)
// entity Customers as SELECT from bp.A_BusinessPartnerType {
//   @title: "ID"    BusinessPartner                                                                       as ID,
//   @title: "Name"  BusinessPartnerFullName                                                               as Name,
//   // actually: get the first email in any of the BP addresses, or null
//   @title: "Email" to_BusinessPartnerAddress[0].to_EmailAddress[IsDefaultEmailAddress=true].EmailAddress as Email
// } where IsNaturalPerson = 'X';

// Make Bookings know about a Customer
extend entity flight.Bookings {
  @title: "Customer"
  Customer: Association to Customers;
};
