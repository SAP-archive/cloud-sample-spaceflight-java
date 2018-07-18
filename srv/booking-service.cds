using teched.flight.trip as flight from '../db';
using BookingService from 'spaceflight-model/srv';
using API_BUSINESS_PARTNER as bp from './external/csn/API_BUSINESS_PARTNER';

  @cds.persistence.skip
  @readonly entity Customers as projection on bp.A_BusinessPartnerType {
    @title: "ID"    BusinessPartner         as ID,
    @title: "Name"  BusinessPartnerFullName as Name,
    @title: "Email" to_BusinessPartnerAddress.to_EmailAddress.EmailAddress as Email
  };

  extend entity flight.Bookings {
    // actually: Association to Customers
    @title: "Customer" Customer: Customers.ID;
  };

