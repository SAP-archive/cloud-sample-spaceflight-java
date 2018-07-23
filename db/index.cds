namespace teched.flight.trip;

using teched.flight.trip as flight from 'spaceflight-model/db';
using API_BUSINESS_PARTNER as bp from '../srv/external/csn/API_BUSINESS_PARTNER';

entity Customers {
  @title: "ID"    key ID:    bp.A_BusinessPartnerType.BusinessPartner;
  @title: "Name"      Name:  bp.A_BusinessPartnerType.BusinessPartnerFullName;
  @title: "Email"     Email: bp.A_AddressEmailAddressType.EmailAddress;
};

extend entity flight.Bookings {
  // actually: Association to Customers
  @title: "Customer"  Customer: Association to Customers;

};
