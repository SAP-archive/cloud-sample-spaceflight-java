namespace teched.flight.trip;

using teched.flight.trip   as flight from './space-model';

// ---------------------------------------------------------------------------------------------------------------------
// 1. Use the imported data model
// ---------------------------------------------------------------------------------------------------------------------
using API_BUSINESS_PARTNER as bp     from '../srv/external/csn/API_BUSINESS_PARTNER';

// ---------------------------------------------------------------------------------------------------------------------
// 2. CustomersRemote: projection on the remote Customer data
// ---------------------------------------------------------------------------------------------------------------------
@cds.persistence.skip
entity CustomersRemote as SELECT from bp.A_BusinessPartnerType {
  @title: "ID"    BusinessPartner                                                                       as ID,
  @title: "Name"  BusinessPartnerFullName                                                               as Name,
  // actually: get the first email in any of the BP addresses, or null
  @title: "Email" to_BusinessPartnerAddress[0].to_EmailAddress[IsDefaultEmailAddress=true].EmailAddress as Email
} where IsNaturalPerson = 'X';

// ---------------------------------------------------------------------------------------------------------------------
// 3. Customers: for replicated customer records
// ---------------------------------------------------------------------------------------------------------------------
@cds.persistence: { skip: false, table: true }  // make the entity a table on DB
entity Customers as projection on CustomersRemote;

// ---------------------------------------------------------------------------------------------------------------------
// 4. Extend Bookings so that is knows about a Customer
// ---------------------------------------------------------------------------------------------------------------------
extend entity flight.Bookings {
  Customer: Association to Customers;
};
