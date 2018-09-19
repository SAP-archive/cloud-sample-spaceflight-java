namespace teched.flight.trip;

using teched.flight.trip   as flight from './space-model';

// ---------------------------------------------------------------------------------------------------------------------
// 1. Use the imported data model
// ---------------------------------------------------------------------------------------------------------------------
using API_BUSINESS_PARTNER as bp     from '../srv/external/csn/ODataServiceforBusinessPartner';

// ---------------------------------------------------------------------------------------------------------------------
// 2. CustomersRemote: projection on the remote Customer data
// ---------------------------------------------------------------------------------------------------------------------
@cds.persistence.skip
entity CustomersRemote as SELECT from bp.A_BusinessPartnerType {
  key BusinessPartner                                                                   as ID,
  BusinessPartnerFullName                                                               as Name,
  // get the default email in any of the BP addresses, or null
  to_BusinessPartnerAddress[0].to_EmailAddress[IsDefaultEmailAddress=true].EmailAddress as Email
}
where IsNaturalPerson = 'X';

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
